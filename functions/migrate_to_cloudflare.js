require("dotenv").config();
const admin = require("firebase-admin");

const API_BASE = process.env.CLOUDFLARE_API_BASE_URL;
const MIGRATION_TOKEN = process.env.CLOUDFLARE_MIGRATION_TOKEN;
const FIREBASE_DATABASE_URL = process.env.FIREBASE_DATABASE_URL;

if (!API_BASE || !MIGRATION_TOKEN || !FIREBASE_DATABASE_URL) {
    console.error("Missing required environment variables.");
    console.error("CLOUDFLARE_API_BASE_URL, CLOUDFLARE_MIGRATION_TOKEN, FIREBASE_DATABASE_URL");
    process.exit(1);
}

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    databaseURL: FIREBASE_DATABASE_URL,
});

const firestore = admin.firestore();
const rtdb = admin.database();

const post = async (path, body) => {
    const response = await fetch(`${API_BASE}${path}`, {
        method: "POST",
        headers: {
            "content-type": "application/json",
            "x-migration-token": MIGRATION_TOKEN,
        },
        body: JSON.stringify(body),
    });

    if (!response.ok) {
        const text = await response.text();
        throw new Error(`POST ${path} failed: ${response.status} ${text}`);
    }
};

const lookup = async (type, number) => {
    if (!number) {
        return { found: false };
    }
    const url = `${API_BASE}/lookup?type=${encodeURIComponent(type)}&number=${encodeURIComponent(number)}`;
    const response = await fetch(url, { method: "GET" });
    if (!response.ok) {
        return { found: false };
    }
    return response.json();
};

const registerUser = async (user) => {
    const response = await fetch(`${API_BASE}/auth/register`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(user),
    });

    if (!response.ok) {
        const text = await response.text();
        console.warn(`Register failed for ${user.phone}: ${response.status} ${text}`);
    }
};

const migrateUsers = async () => {
    const snapshot = await rtdb.ref("auth").get();
    if (!snapshot.exists()) {
        console.log("No auth users found in Realtime Database.");
        return;
    }
    const users = snapshot.val();
    const entries = Object.values(users);
    for (const entry of entries) {
        if (!entry?.phone || !entry?.password || !entry?.email || !entry?.name) {
            continue;
        }
        await registerUser({
            name: entry.name,
            email: entry.email,
            phone: entry.phone,
            password: entry.password,
        });
    }
    console.log(`Migrated ${entries.length} users.`);
};

const migrateCollection = async (collectionName, handler) => {
    const snapshot = await firestore.collection(collectionName).get();
    if (snapshot.empty) {
        console.log(`No data in ${collectionName}.`);
        return;
    }
    let migrated = 0;
    let skipped = 0;
    let failed = 0;
    for (const doc of snapshot.docs) {
        try {
            const result = await handler(doc.data(), doc);
            if (result === false) {
                skipped += 1;
            } else {
                migrated += 1;
            }
        } catch (error) {
            failed += 1;
            console.warn(`Failed ${collectionName} doc ${doc.id}: ${error.message}`);
        }
    }
    console.log(`Migrated ${migrated} records from ${collectionName}. Skipped ${skipped}, failed ${failed}.`);
};

const migrateDonors = async (bloodType) => {
    await migrateCollection(bloodType, async (data) => {
        if (!data?.name || !data?.number || !data?.location) {
            return false;
        }
        const existing = await lookup("donor", data.number);
        if (existing?.found) {
            return false;
        }
        await post("/donors", {
            name: data.name,
            phone: data.number,
            location: data.location,
            bloodType,
        });
    });
};

const migrateDoctors = async () => {
    await migrateCollection("Doctor", async (data) => {
        if (!data?.name || !data?.number || !data?.specialization || !data?.presence || !data?.title) {
            return false;
        }
        const existing = await lookup("doctor", data.number);
        if (existing?.found) {
            return false;
        }
        await post("/doctors", {
            name: data.name,
            phone: data.number,
            specialization: data.specialization,
            presence: data.presence,
            title: data.title,
        });
    });
};

const migrateProfessions = async () => {
    await migrateCollection("professions", async (data) => {
        if (!data?.name || !data?.number || !data?.nameProfession) {
            return false;
        }
        const existing = await lookup("profession", data.number);
        if (existing?.found) {
            return false;
        }
        await post("/professions", {
            name: data.name,
            phone: data.number,
            nameProfession: data.nameProfession,
        });
    });
};

const migrateCars = async () => {
    await migrateCollection("line", async (data) => {
        if (!data?.name || !data?.number || !data?.type || !data?.time || !data?.from) {
            return false;
        }
        const existing = await lookup("car", data.number);
        if (existing?.found) {
            return false;
        }
        await post("/cars", {
            name: data.name,
            phone: data.number,
            vehicleType: data.type,
            time: data.time,
            routeFrom: data.from,
        });
    });
};

const migrateSatota = async () => {
    await migrateCollection("Satota", async (data) => {
        if (!data?.name || !data?.number || !data?.location) {
            return false;
        }
        const existing = await lookup("satota", data.number);
        if (existing?.found) {
            return false;
        }
        await post("/satota", {
            name: data.name,
            phone: data.number,
            location: data.location,
        });
    });
};

const run = async () => {
    await migrateUsers();
    await migrateDonors("A+");
    await migrateDonors("A-");
    await migrateDonors("B+");
    await migrateDonors("B-");
    await migrateDonors("O+");
    await migrateDonors("O-");
    await migrateDonors("AB+");
    await migrateDonors("AB-");
    await migrateDoctors();
    await migrateProfessions();
    await migrateCars();
    await migrateSatota();
    console.log("Migration complete.");
    process.exit(0);
};

run().catch((error) => {
    console.error("Migration failed:", error);
    process.exit(1);
});
