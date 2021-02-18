FROM python:3
ADD add.py /
RUN pip install flask
RUN pip install flask_restful
CMD [ "python", "./add.py"]
