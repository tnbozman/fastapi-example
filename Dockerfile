# https://hub.docker.com/_/python
# https://fastapi.tiangolo.com/deployment/docker/#dockerfile
# pull official base image
FROM python:3.12.2-slim

ARG USERNAME=devUser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# set work directory
WORKDIR /src

# copy requirements file
COPY ./requirements.txt /src/requirements.txt

# copy project
COPY ./app /src/app

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

USER $USERNAME


# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
CMD ["gunicorn", "app.main:app", "-k", "uvicorn.workers.UvicornWorker", "--workers", "4", "--bind", "0.0.0.0:8000"]