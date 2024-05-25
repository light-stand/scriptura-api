import basencode
import random


def random_string(length):
    return basencode.Number(random.random()).repr_in_base(36)[2:][:length]
