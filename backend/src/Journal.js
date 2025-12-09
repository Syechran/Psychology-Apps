const db = require("./config/firebase");

// --- Journal Controller Logic ---

// Function to get all journals
const getAllJournals = async (req, res) => {
  try {
    const journalsRef = db.collection("journals");
    const snapshot = await journalsRef.orderBy("created_at", "desc").get();
    const journals = [];
    snapshot.forEach((doc) => {
      const data = doc.data();
      journals.push({
        id: doc.id,
        title: data.title,
        content: data.content,
        created_at: data.created_at.toDate(), // Convert Firestore Timestamp to JavaScript Date
        time_formatted: data.created_at.toDate().toISOString(), // Optional: for frontend display
      });
    });

    res.status(200).json(journals);
  } catch (error) {
    console.error("Error getting journals:", error);
    res.status(500).json({ error: "Failed to retrieve journals" });
  }
};

const createJournal = async (req, res) => {
  try {
    const { title, content } = req.body;

    if (!title || !content) {
      return res.status(400).json({ error: "Title and content cannot be empty" });
    }

    const newJournalRef = db.collection("journals").doc();
    const newJournal = {
      title,
      content,
      created_at: new Date(), // Server-generated timestamp
    };

    await newJournalRef.set(newJournal);

    res.status(201).json({ id: newJournalRef.id, ...newJournal, time_formatted: newJournal.created_at.toISOString() });
  } catch (error) {
    console.error("Error creating journal:", error);
    res.status(500).json({ error: "Failed to create journal" });
  }
};

module.exports = {
  getAllJournals,
  createJournal,
};
