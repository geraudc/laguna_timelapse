import json

with open('config.json', "r+") as jsonFile :
    data = json.load(jsonFile)

    def getImageWidth() :
        return data["image_width"]

    def getImageHeight() :
        return data["image_height"]

    def getCaptureDelay() :
        return data["capture_delay"]

    def setImageWidth(new_width) :
        tmp = data["image_width"]
        data["image_width"] = new_width

        jsonFile.seek(0)  # rewind
        json.dump(data, jsonFile)
        jsonFile.truncate()
