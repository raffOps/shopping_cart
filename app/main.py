from adapters.rest.v1.handler import app

if __name__ == '__main__':
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=9000)
