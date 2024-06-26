from datetime import datetime, timedelta
import bcrypt
import jwt
from flask import request, jsonify, abort

from app import app
from app.models import User


@app.post("/api/users/register")
def register():
    username = request.json.get("username")
    user_ = User.get_user_by_username(username)
    if user_:
        abort(403, f"User with name {username} already exist")

    password = request.json.get("password")
    byte_password = bytes(password, "utf-8")
    hashed_password = bcrypt.hashpw(password=byte_password, salt=bcrypt.gensalt(8))
    new_user = User(username=username, password=hashed_password)
    new_user.save()

    expiration = datetime.utcnow() + timedelta(days=1)
    payload = {
        "id": new_user.id,
        "username": username,
        "exp": expiration,
    }
    token = jwt.encode(
        payload=payload,
        key=app.config["SECRET_KEY"],
        algorithm="HS256",
    )

    data = {
        "username": username,
        "statusMessage": "Success create new account",
        "token": token,
    }

    return jsonify({"data": data, "success": True, "error": None}), 201


@app.post("/api/users/login")
def login():
    username = request.json.get("username")
    user = User.get_user_by_username(username)
    if not user:
        abort(404, f"User with name {username} do not exist")

    password = request.json.get("password")
    byte_password = bytes(str(password), "utf-8")
    if not bcrypt.checkpw(byte_password, user.password):
        abort(403, "Unauthorized")

    expiration = datetime.utcnow() + timedelta(days=1)
    payload = {
        "id": user.id,
        "username": username,
        "exp": expiration,
    }
    token = jwt.encode(
        payload=payload,
        key=app.config["SECRET_KEY"],
        algorithm="HS256",
    )

    data = {
        "username": username,
        "statusMessage": "Login Successful",
        "token": token,
    }

    return jsonify({"data": data, "success": True, "error": None}), 202
