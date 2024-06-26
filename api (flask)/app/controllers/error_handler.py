from flask import jsonify

from app import app


@app.errorhandler(404)
def handler_404(err):
    error = {"name": err.name, "message": err.description}
    return jsonify({"success": False, "error": error, "data": None}), 404


@app.errorhandler(403)
def handler_403(err):
    error = {"name": err.name, "message": err.description}
    return jsonify({"success": False, "error": error, "data": None}), 403


@app.errorhandler(401)
def handler_401(err):
    error = {"name": err.name, "message": err.description}
    return jsonify({"success": False, "error": error, "data": None}), 401
