FROM ubuntu:22.04
WORKDIR /app

# Copy native binary
COPY deploy/WebSocketDemo /app/WebSocketDemo
RUN chmod +x /app/WebSocketDemo

# Expose port Render will use
EXPOSE 10000

# Start your app
CMD ["./WebSocketDemo"]

