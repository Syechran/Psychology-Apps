const express = require("express");
const journalController = require("../Journal");
const router = express.Router();

// Route to get all journals
router.get("/journals", journalController.getAllJournals);

// Route to create a new journal
router.post("/journals", journalController.createJournal);

// Route to update a journal
router.put("/journals/:id", journalController.updateJournal);

// Route to delete a journal
router.delete("/journals/:id", journalController.deleteJournal);

module.exports = router;
