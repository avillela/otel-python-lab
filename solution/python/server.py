from flask import Flask
from random import randint

from opentelemetry import trace, metrics
import logging


app = Flask(__name__)

@app.route("/rolldice")
def roll_dice():
    return str(do_roll())

def do_roll():
    res = randint(1, 6)

    with tracer.start_as_current_span("do_roll"):
        current_span = trace.get_current_span()
        current_span.set_attribute("roll.value", res)
        current_span.add_event("This is a span event")

        logging.getLogger().error("This is a log message")

        request_counter.add(1)

    return res

if __name__ == "__main__":
    # Init tracer
    tracer = trace.get_tracer_provider().get_tracer(__name__)

    # Init metrics + create a counter instrument
    meter = metrics.get_meter_provider().get_meter(__name__)
    request_counter = meter.create_counter(name="request_counter", description="Number of requests", unit="1")

    app.run(host="0.0.0.0", port=8082, debug=True, use_reloader=False)