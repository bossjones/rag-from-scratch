#!/usr/bin/env python
"""_summary_"""
import requests

# Unlike with our StdOut streaming, we now need to send our
# tokens to a generator function that feeds those
# tokens to FastAPI via a StreamingResponse object.
# To handle this we need to use async code,
# otherwise our generator will not begin emitting
# anything until after generation is already complete.

# The Queue is accessed by our callback handler,
# as as each token is generated, it puts the token into the queue.
# Our generator function asyncronously checks for new tokens being
# added to the queue. As soon as the generator sees a
# token has been added, it gets the token and yields it to our StreamingResponse.

# To see it in action, we'll define a stream requests function called get_stream:

def get_stream(query: str):
    """_summary_

    Args:
        query (str): _description_
    """
    s = requests.Session()
    with s.get(
        "http://localhost:8000/chat",
        stream=True,
        json={"text": query}
    ) as r:
        for line in r.iter_content():
            print(line.decode("utf-8"), end="")

get_stream("hi there!")
