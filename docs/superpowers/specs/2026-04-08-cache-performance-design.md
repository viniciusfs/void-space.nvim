# Spec: void-space.nvim — Cache em Disco para Performance de Carregamento

**Data:** 2026-04-08

---

## Context

O tema void-space.nvim carrega em 3–5ms. Isso é causado por:
- 25 `require()` separados (um por módulo de highlight)
- ~1000+ chamadas `vim.api.nvim_set_hl()` a cada carga
- Merge de tabelas em Lua durante cada inicialização

Temas populares como tokyonight e catppuccin atingem 0.Xms usando cache em disco: na primeira carga computam tudo normalmente e salvam o resultado em um arquivo `.lua` flat. Nas cargas seguintes, fazem `dofile()` nesse arquivo, pulando toda a lógica de computação.

O objetivo é reduzir cargas subsequentes de ~4ms para ~0.4ms sem alterar a arquitetura existente.

---

## Arquitetura

### Novo arquivo

**`lua/void-space/cache.lua`** — módulo com responsabilidade única:

| Função | Descrição |
|--------|-----------|
| `cache.path(opts)` | Retorna o caminho do arquivo de cache para a config atual |
| `cache.load(opts)` | Tenta carregar do cache; retorna tabela de highlights ou `nil` |
| `cache.save(opts, highlights)` | Serializa e salva a tabela em disco |
| `cache.clear()` | Remove todos os arquivos de cache do diretório |

### Localização do cache

```
~/.cache/nvim/void-space/<hash>.lua
```

`vim.fn.stdpath("cache")` resolve o caminho base — sem hardcode de `~/.cache/nvim`.

### Geração do hash (nome do arquivo)

```lua
local function cache_key(opts)
  return string.format("%s_t%d_i%d%d_d%d",
    opts.variant,
    opts.transparent and 1 or 0,
    opts.italic_comments and 1 or 0,
    opts.italic_keywords and 1 or 0,
    opts.dim_inactive and 1 or 0
  )
end
-- exemplo: "deep_space_t0_i10_d0"
```

A invalidação é implícita: se a config muda, o hash muda, um novo arquivo é gerado. Arquivos velhos ficam em disco mas nunca são carregados.

### Formato do arquivo de cache

Arquivo `.lua` que retorna a tabela flat de highlights — sem lógica, sem condicionais, sem requires:

```lua
-- void-space cache — gerado automaticamente, não editar
return {
  ["Normal"] = { fg = "#c8cfe8", bg = "#0d1220" },
  ["CursorLine"] = { bg = "#1a2035" },
  ["@keyword"] = { fg = "#8899cc", italic = true },
  -- ... ~1000 entradas
}
```

### Serialização

Função Lua pura em `cache.lua` — sem dependências externas:

```lua
local function serialize(hl)
  local lines = { "-- void-space cache -- gerado automaticamente, nao editar", "return {" }
  for group, spec in pairs(hl) do
    lines[#lines + 1] = string.format("  [%q] = {", group)
    for k, v in pairs(spec) do
      if type(v) == "string" then
        lines[#lines + 1] = string.format("    %s = %q,", k, v)
      elseif type(v) == "boolean" then
        lines[#lines + 1] = string.format("    %s = %s,", k, tostring(v))
      end
    end
    lines[#lines + 1] = "  },"
  end
  lines[#lines + 1] = "}"
  return table.concat(lines, "\n")
end
```

---

## Mudanças em arquivos existentes

### `lua/void-space/init.lua`

Adicionar lógica de cache no início de `M.load()`. Se cache existe, aplica diretamente e retorna cedo. Se não existe, executa fluxo normal e salva o cache ao final.

Terminal colors são sempre aplicadas em ambos os paths. O callback `on_highlights` é sempre executado em ambos os paths — o cache salva apenas o tema base (sem overrides do usuário), e o callback é aplicado sobre ele a cada carga (operação rápida, apenas uma chamada de função sobre uma tabela já carregada).

### Comando de usuário (dentro de `init.lua`)

```lua
vim.api.nvim_create_user_command("VoidSpaceClearCache", function()
  require("void-space.cache").clear()
  vim.notify("void-space: cache cleared", vim.log.levels.INFO)
end, {})
```

---

## O que NÃO muda

- `palette.lua`, `theme.lua`, todos os módulos em `highlights/`
- `lua/lualine/themes/void-space.lua`
- A suite de testes existente (`spec/`)

---

## Testes novos

**`spec/cache_spec.lua`** cobrindo:

1. `cache.load()` retorna `nil` quando cache não existe
2. `cache.save()` + `cache.load()` round-trip preserva a tabela de highlights intacta
3. Configs diferentes geram caminhos de arquivo diferentes
4. `cache.clear()` remove os arquivos gerados

---

## Fluxo de carga após a mudança

```
colorscheme void-space
  └─ init.lua: M.load()
       ├─ cache.load(config) → tabela?
       │    ├─ SIM (~0.4ms total) → aplicar highlights → terminal colors → fim
       │    └─ NÃO (~4ms total) → theme.get() → on_highlights → cache.save() → aplicar highlights → terminal colors → fim
```

---

## Arquivos críticos

| Arquivo | Ação |
|---------|------|
| `lua/void-space/init.lua` | Modificar `M.load()` para tentar cache antes de `theme.get()` |
| `lua/void-space/cache.lua` | Criar — toda lógica de cache |
| `spec/cache_spec.lua` | Criar — testes do módulo de cache |

---

## Verificação

1. `make test` — todos os testes existentes continuam passando
2. `busted --config-file=.busted spec/cache_spec.lua` — novos testes passam
3. Dentro do Neovim: `:colorscheme void-space` gera o arquivo em `~/.cache/nvim/void-space/`
4. Segunda carga perceptivelmente mais rápida no LazyVim (verificar com `:Lazy profile`)
5. `:VoidSpaceClearCache` remove os arquivos e força regeneração na próxima carga
