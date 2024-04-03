from flask import request, jsonify, abort

from app import app
from app.models import Message
from .middleware import deserialize_auth


@app.post("/api/messages")
@deserialize_auth
def new_message(current_user):
    # payload = new_message.auth_payload
    text = request.json.get("text")
    message = Message(text=text, sender_id=current_user["id"])
    message.save()
    # print(message.sender, message.text)
    # print(type(message.sender.user))

    data = {
        "id": message.id,
        "text": message.text,
        "sender": message.sender.username
    }

    return jsonify({"data": data, "success": True, "error": None}), 201
