FROM python:3.7
COPY __init__.py /app/server/
COPY entities /app/server/
COPY main.py /app/server/
WORKDIR /app/server
RUN pip install sqlalchemy psycopg2-binary flask marshmallow flask-cors
EXPOSE 5000
CMD ["flask", "run", "--host", "0.0.0.0", "--port", "5000"]
