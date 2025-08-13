from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import get_db
from pydantic import BaseModel   # <-- missing import

app = FastAPI()

@app.get("/")
def hello(db: Session = Depends(get_db)):
    return {"message": "Hello from FastAPI to Supabase PostgreSQL!"}

user = []

class User(BaseModel):
    id: int
    name: str
    email: str

@app.post("/users/")   # decorator must be followed immediately by a function
def create_user(new_user: User):
    user.append(new_user)
    return {"message": "User created successfully", "user": new_user}
