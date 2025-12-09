const express = require("express");
const journalController = require("../Journal");
const router = express.Router();

// Route to get all journals
router.get("/journals", journalController.getAllJournals);

// Route to create a new journal
router.post("/journals", journalController.createJournal);

module.exports = router;
