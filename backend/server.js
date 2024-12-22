const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require("cors");
const multer = require("multer");
const path = require("path");
const fs = require("fs"); 

const app = express();
const uploadDirectory = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadDirectory)) {
  fs.mkdirSync(uploadDirectory, { recursive: true });
}


app.use(cors({
  origin: '*', 
}));
app.use(bodyParser.json());

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDirectory);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname)); 
  },
});
const upload = multer({ storage });



mongoose
  .connect("mongodb://localhost:27017/adopet", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("MongoDB Connected"))
  .catch((err) => console.error("Error connecting to MongoDB:", err));



const dogSchema = new mongoose.Schema({
  name: String,
  age: Number,
  gender: String,
  color: String,
  weight: Number,
  location: String,
  image: String,
  about: String,
});
const Dog = mongoose.model("Dog", dogSchema);



app.get("/dogs", async (req, res) => {
  try {
    const dogs = await Dog.find();
    res.json(dogs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});



app.post("/dogs", upload.single("image"), async (req, res) => {
  try {
    const dogData = req.body;
    if (req.file) {
      dogData.image = `/uploads/${req.file.filename}`;

    }

    const newDog = new Dog(dogData);
    await newDog.save();
    res.status(201).json(newDog);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});




app.use("/uploads", express.static("uploads"));

app.put("/dogs/:id", upload.single("image"), async (req, res) => {
  try {
    console.log("Request Body:", req.body);
    console.log("File:", req.file);

    const updatedData = req.body;
    if (req.file) {
      updatedData.image = `/uploads/${req.file.filename}`;
    }

    const updatedDog = await Dog.findByIdAndUpdate(req.params.id, updatedData, { new: true });
    if (!updatedDog) {
      return res.status(404).json({ error: "Dog not found" });
    }

    res.json(updatedDog);
  } catch (err) {
    console.error("Error in updating dog:", err);
    res.status(500).json({ error: err.message });
  }
});



app.delete("/dogs/:id", async (req, res) => {
  try {
    await Dog.findByIdAndDelete(req.params.id);
    res.json({ message: "Dog deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


const PORT = 5000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
