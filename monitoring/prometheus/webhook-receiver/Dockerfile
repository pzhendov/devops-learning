FROM python:3.13-alpine

WORKDIR /app

COPY app.py .

RUN addgroup -S webhook \
    && adduser -S -G webhook webhook

USER webhook

EXPOSE 8080

CMD ["python", "-u", "app.py"]
