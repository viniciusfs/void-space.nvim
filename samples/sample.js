/**
 * Void Space Theme — JavaScript Sample
 * Demonstrates: classes, async/await, closures, generators, destructuring,
 * template literals, symbols, WeakMap, Proxy, and modern JS patterns.
 */

'use strict';

// Constants

const VERSION = '1.0.0';
const MAX_RETRIES = 3;
const PI = Math.PI;
const NONE = null;

/** @type {Record<string, string>} */
const PALETTE = Object.freeze({
  void:   '#0d0f18',
  nebula: '#c792ea',
  aurora: '#89ddff',
  comet:  '#82aaff',
  pulsar: '#ff5370',
});

const SYM_PRIVATE = Symbol('private');


// Enum-like object

const SpectralClass = Object.freeze({
  O: 'O', B: 'B', A: 'A', F: 'F', G: 'G', K: 'K', M: 'M',
});


// Class hierarchy

class CelestialBody {
  #name;

  constructor(name) {
    if (new.target === CelestialBody) {
      throw new TypeError('CelestialBody is abstract');
    }
    this.#name = String(name);
  }

  get name() { return this.#name; }

  describe() {
    throw new Error(`${this.constructor.name}.describe() not implemented`);
  }

  toString() { return `[${this.constructor.name} "${this.name}"]`; }
}


class Star extends CelestialBody {
  #observations = 0;
  [SYM_PRIVATE] = {};

  /**
   * @param {string}   name
   * @param {number}   massSolar      - solar masses
   * @param {number}   luminosity     - solar luminosities
   * @param {string[]} [tags]
   */
  constructor(name, massSolar, luminosity, tags = []) {
    super(name);
    if (massSolar <= 0) throw new RangeError(`mass must be positive, got ${massSolar}`);
    this.massSolar   = massSolar;
    this.luminosity  = luminosity;
    this.tags        = [...tags];
  }

  get spectralClass() {
    const m = this.massSolar;
    if (m >= 16)   return SpectralClass.O;
    if (m >= 2.1)  return SpectralClass.B;
    if (m >= 1.4)  return SpectralClass.A;
    if (m >= 1.04) return SpectralClass.F;
    if (m >= 0.8)  return SpectralClass.G;
    if (m >= 0.45) return SpectralClass.K;
    return SpectralClass.M;
  }

  observe() { this.#observations++; }
  get observationCount() { return this.#observations; }

  describe() {
    return `${this.name} [class ${this.spectralClass}, ` +
           `mass=${this.massSolar.toFixed(2)}☉, lum=${this.luminosity.toExponential(2)}☉]`;
  }

  toJSON() {
    return { name: this.name, spectralClass: this.spectralClass,
             massSolar: this.massSolar, luminosity: this.luminosity, tags: this.tags };
  }
}


// Mixin pattern

const Serialisable = (Base) => class extends Base {
  serialise() { return JSON.stringify(this); }

  static deserialise(json) {
    const { name, massSolar, luminosity, tags } = JSON.parse(json);
    return new this(name, massSolar, luminosity, tags);
  }
};

class SerialisableStar extends Serialisable(Star) {}


// Decorator (stage-3 via manual wrapping)

function retry(times = 3) {
  return function (fn) {
    return async function (...args) {
      let lastErr;
      for (let attempt = 0; attempt < times; attempt++) {
        try {
          return await fn.apply(this, args);
        } catch (err) {
          lastErr = err;
          console.warn(`[retry] attempt ${attempt + 1}/${times} failed:`, err.message);
        }
      }
      throw new Error(`All ${times} attempts failed`, { cause: lastErr });
    };
  };
}

const fetchStarData = retry(MAX_RETRIES)(async function (starId) {
  if (typeof starId !== 'number' || starId < 0) {
    throw new TypeError(`Invalid starId: ${starId}`);
  }
  // Simulated async fetch
  await delay(10);
  return { id: starId, name: 'Sirius', massSolar: 2.1 };
});


// Async / Promise

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function observeStar(star, durationMs = 50) {
  await delay(durationMs);
  star.observe();
  return `Observed ${star.name} — ${star.observationCount} observation(s)`;
}

async function surveyAll(stars) {
  const results = await Promise.all(stars.map((s) => observeStar(s)));
  return results;
}


// Generator

function* fibonacci() {
  let [a, b] = [0, 1];
  while (true) {
    yield a;
    [a, b] = [b, a + b];
  }
}

function firstN(gen, n) {
  const out = [];
  for (const val of gen) {
    out.push(val);
    if (out.length >= n) break;
  }
  return out;
}


// Proxy

function makeReadonly(obj) {
  return new Proxy(obj, {
    set(_, prop) {
      throw new TypeError(`Cannot set property "${prop}" on a read-only object`);
    },
    deleteProperty(_, prop) {
      throw new TypeError(`Cannot delete property "${prop}" on a read-only object`);
    },
  });
}


// Closure / IIFE

const makeCounter = (start = 0) => {
  let n = start;
  return {
    next:  () => ++n,
    reset: () => { n = start; },
    value: () => n,
  };
};

const catalogueSize = (() => {
  const sizes = [1024, 2048, 4096];
  return sizes.reduce((acc, s) => acc + s, 0);
})();


// Destructuring & spread

const [primary, ...rest] = ['void', 'nebula', 'aurora', 'comet'];
const { void: bg, nebula: accent, ...others } = PALETTE;

function formatStar({ name, massSolar, luminosity, tags = [] }) {
  return `${name} (${massSolar}☉) [${tags.join(', ')}]`;
}


// Tagged template literal

function highlight(strings, ...values) {
  return strings.reduce((acc, str, i) => {
    const val = values[i] !== undefined ? `\x1b[33m${values[i]}\x1b[0m` : '';
    return acc + str + val;
  }, '');
}


// WeakMap (private data pattern)

const _secrets = new WeakMap();

class Observatory {
  constructor(location, apertureMm) {
    _secrets.set(this, { location, apertureMm, log: [] });
  }

  record(entry) {
    _secrets.get(this).log.push({ ts: Date.now(), entry });
  }

  report() {
    const { location, apertureMm, log } = _secrets.get(this);
    return { location, apertureMm, entries: log.length };
  }
}


// Error subclass

class ObservationError extends Error {
  constructor(starName, cause) {
    super(`Observation of "${starName}" failed`);
    this.name      = 'ObservationError';
    this.starName  = starName;
    this.cause     = cause;
  }
}


// Entry point

(async () => {
  console.log(`void-space v${VERSION} — Pi ≈ ${PI.toFixed(6)}`);

  const sirius     = new Star('Sirius',           2.10,  25.4,  ['bright', 'binary']);
  const betelgeuse = new Star('Betelgeuse',       20.0,  1e5,   ['red-supergiant']);
  const proxima    = new Star('Proxima Centauri', 0.12,  0.0017);

  const stars = [sirius, betelgeuse, proxima];

  stars.forEach((s) => console.log(s.describe()));

  // Async survey
  const observations = await surveyAll(stars);
  observations.forEach((r) => console.log(' >', r));

  // Fetch with retry
  const data = await fetchStarData(42);
  console.log('Fetched:', data);

  // Generator
  const fibs = firstN(fibonacci(), 10);
  console.log('Fibonacci:', fibs);

  // Closure counter
  const counter = makeCounter(0);
  [1, 2, 3, 4, 5].forEach(() => console.log('tick', counter.next()));

  // Tagged template
  console.log(highlight`Star ${sirius.name} has class ${sirius.spectralClass}`);

  // Destructuring
  console.log(`Primary colour key: ${primary}, rest: ${rest.join(', ')}`);
  console.log(`bg=${bg}, accent=${accent}`);
  console.log(formatStar({ name: 'Sirius', massSolar: 2.1, luminosity: 25, tags: ['bright'] }));

  // Proxy readonly
  const ro = makeReadonly({ answer: 42 });
  try { ro.answer = 0; } catch (e) { console.log('readonly error:', e.message); }

  // Observatory
  const obs = new Observatory('Mauna Kea', 10000);
  stars.forEach((s) => obs.record(s.describe()));
  console.log(obs.report());

  // Error subclass
  const obsErr = new ObservationError('Ghost', new Error('not found'));
  console.log(obsErr.message, '—', obsErr instanceof Error);

  console.log(`catalogueSize=${catalogueSize}`);
  console.log(`Serialised: ${new SerialisableStar('Sol', 1, 1).serialise()}`);
})();
