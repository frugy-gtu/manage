from typing import Literal, Union

filter_type = Union[
    Literal['=='],
    Literal['!='],
    Literal['in'],
    Literal['<'],
    Literal['>'],
    Literal['<='],
    Literal['>='],
    Literal['ilike'],
    Literal['special'],
]
