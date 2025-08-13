from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import get_db

app = FastAPI()

@app.get("/")
def hello(db: Session = Depends(get_db)):
    return {"message": "Hello from FastAPI to Supabase PostgreSQL!"}

user = []

class User(BaseModel):
    id: int
    name: str
    email: str

@app.post("/users/")