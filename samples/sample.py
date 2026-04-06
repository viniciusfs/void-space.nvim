#!/usr/bin/env python3
"""
Void Space Theme - Python Sample
Demonstrates: types, functions, classes, decorators, comprehensions, exceptions.
"""

from __future__ import annotations

import os
import sys
import math
import asyncio
from dataclasses import dataclass, field
from typing import Optional, Union, Generator
from enum import Enum, auto


# Constants

VERSION: str = "1.0.0"
MAX_RETRIES: int = 3
PI: float = math.pi
EMPTY: None = None

PALETTE: dict[str, str] = {
    "void":    "#0d0f18",
    "nebula":  "#c792ea",
    "aurora":  "#89ddff",
    "comet":   "#82aaff",
}


# Enum

class Planet(Enum):
    MERCURY = auto()
    VENUS   = auto()
    EARTH   = auto()
    MARS    = auto()

    def distance_from_sun(self) -> float:
        """Returns approximate distance in AU."""
        distances = {
            Planet.MERCURY: 0.39,
            Planet.VENUS:   0.72,
            Planet.EARTH:   1.00,
            Planet.MARS:    1.52,
        }
        return distances[self]


# Dataclass

@dataclass
class Star:
    name: str
    mass: float                        # solar masses
    luminosity: float                  # solar luminosities
    tags: list[str] = field(default_factory=list)
    _cache: dict = field(default_factory=dict, repr=False)

    def __post_init__(self) -> None:
        if self.mass <= 0:
            raise ValueError(f"Mass must be positive, got {self.mass}")

    @property
    def spectral_class(self) -> str:
        if self.mass >= 16:   return "O"
        if self.mass >= 2.1:  return "B"
        if self.mass >= 1.4:  return "A"
        if self.mass >= 1.04: return "F"
        if self.mass >= 0.8:  return "G"
        if self.mass >= 0.45: return "K"
        return "M"

    def __repr__(self) -> str:
        return f"Star(name={self.name!r}, class={self.spectral_class})"


# Decorator

def retry(times: int = 3):
    """Decorator that retries a function on exception."""
    def decorator(fn):
        def wrapper(*args, **kwargs):
            last_exc: Optional[Exception] = None
            for attempt in range(times):
                try:
                    return fn(*args, **kwargs)
                except Exception as exc:
                    last_exc = exc
                    print(f"[retry] attempt {attempt + 1}/{times} failed: {exc}")
            raise RuntimeError(f"All {times} attempts failed") from last_exc
        return wrapper
    return decorator


@retry(times=MAX_RETRIES)
def fetch_star_data(star_id: int) -> dict:
    if star_id < 0:
        raise ValueError(f"Invalid star_id: {star_id}")
    return {"id": star_id, "name": "Sirius", "mass": 2.1}


# Generator / comprehension

def fibonacci() -> Generator[int, None, None]:
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b


def first_n_fibs(n: int) -> list[int]:
    gen = fibonacci()
    return [next(gen) for _ in range(n)]


squares = {x: x**2 for x in range(1, 11)}
evens   = [n for n in range(100) if n % 2 == 0]
matrix  = [[row * col for col in range(1, 4)] for row in range(1, 4)]


# Async

async def observe(star: Star, duration: float) -> str:
    await asyncio.sleep(duration)
    return f"Observed {star.name} for {duration:.2f}s — class {star.spectral_class}"


async def survey(stars: list[Star]) -> list[str]:
    tasks = [observe(s, 0.01) for s in stars]
    return await asyncio.gather(*tasks)


# Context manager

class Telescope:
    def __init__(self, aperture_mm: int) -> None:
        self.aperture = aperture_mm
        self._open = False

    def __enter__(self) -> "Telescope":
        self._open = True
        print(f"Telescope ({self.aperture}mm) opened")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb) -> bool:
        self._open = False
        print("Telescope closed")
        return False   # do not suppress exceptions

    def observe(self, target: str) -> None:
        if not self._open:
            raise RuntimeError("Telescope is closed")
        print(f"Observing: {target}")


# Union / match

def describe(obj: Union[Star, Planet, str]) -> str:
    match obj:
        case Star(name=n, mass=m) if m > 10:
            return f"{n} is a massive star"
        case Star(name=n):
            return f"{n} is an ordinary star"
        case Planet.EARTH:
            return "Home planet"
        case Planet():
            return f"Planet: {obj.name}"
        case str(s):
            return f"Unknown: {s}"
        case _:
            return "Unrecognised object"


# Entry point

def main() -> int:
    sirius  = Star("Sirius",  mass=2.10, luminosity=25.4, tags=["bright", "binary"])
    betelgeuse = Star("Betelgeuse", mass=20.0, luminosity=1e5)

    stars = [sirius, betelgeuse]

    print(f"void-space v{VERSION}")
    print(f"Pi ≈ {PI:.6f}")
    print(f"Fibonacci(10): {first_n_fibs(10)}")
    print(f"Squares: {squares}")

    for s in stars:
        print(describe(s))

    print(f"Earth is {Planet.EARTH.distance_from_sun()} AU from the Sun")

    with Telescope(aperture_mm=200) as scope:
        scope.observe("Andromeda Galaxy")

    results = asyncio.run(survey(stars))
    for r in results:
        print(r)

    env_home = os.environ.get("HOME", "/tmp")
    print(f"Running on {sys.platform}, HOME={env_home}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
