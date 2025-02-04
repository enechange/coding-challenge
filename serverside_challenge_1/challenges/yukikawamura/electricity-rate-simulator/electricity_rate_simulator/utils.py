from pathlib import Path
import logging


BASE_DIR = Path(__file__).parents[0]
DATA_DIR = BASE_DIR.joinpath("data")
PROVIDER_DIR = DATA_DIR.joinpath("provider")


def setup_logging(debug_mode=False):
    lgr = logging.getLogger("uvicorn.app")
    log_format = "%(asctime)s:[%(levelname)s] %(message)s"
    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(log_format)
    level = logging.DEBUG if debug_mode else logging.INFO

    lgr.setLevel(level)
    lgr.addHandler(stream_handler)
    return lgr
