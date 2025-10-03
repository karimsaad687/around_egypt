import Foundation
import SQLite3

class SQLiteDatabase {
    static let shared = SQLiteDatabase()
    
    private var db: OpaquePointer?
    private let databaseName = "around_egypt.sqlite"
    
    private init() {
        setupDatabase()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    private func setupDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databaseName)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        createTables()
        print("SQLite database initialized successfully at: \(fileURL.path)")
    }
    
    private func createTables() {
        // Create cities table
        let createCitiesTable = """
        CREATE TABLE IF NOT EXISTS cities (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            disable TEXT,
            topPick INTEGER DEFAULT 0
        );
        """
        
        // Create places table
        let createPlacesTable = """
        CREATE TABLE IF NOT EXISTS places (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            coverPhoto TEXT NOT NULL,
            descriptionText TEXT NOT NULL,
            viewsNo INTEGER DEFAULT 0,
            likesNo INTEGER DEFAULT 0,
            recommended INTEGER DEFAULT 0,
            detailedDescription TEXT NOT NULL,
            address TEXT NOT NULL,
            isLiked INTEGER DEFAULT 0,
            lastUpdated REAL NOT NULL,
            cityId INTEGER,
            FOREIGN KEY (cityId) REFERENCES cities(id)
        );
        """
        
        executeSQL(createCitiesTable)
        executeSQL(createPlacesTable)
    }
    
    private func executeSQL(_ sql: String) {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                let error = String(cString: sqlite3_errmsg(db))
                print("Error executing SQL: \(error)")
            }
        } else {
            let error = String(cString: sqlite3_errmsg(db))
            print("Error preparing SQL: \(error)")
        }
        
        sqlite3_finalize(statement)
    }
}

// MARK: - CRUD Operations
extension SQLiteDatabase {
    
    // MARK: - Save Operations
    func savePlace(_ place: Place) {
        // Save city first
        saveCity(place.city)
        
        // Check if place exists
        if fetchPlace(by: place.id) != nil {
            updatePlace(place)
        } else {
            insertPlace(place)
        }
    }
    
    func savePlaces(_ places: [Place]) {
        print("Saving \(places.count) places to database...")
        places.forEach { savePlace($0) }
        print("Finished saving places to database")
    }
    
    private func saveCity(_ city: City) {
        let sql = """
        INSERT OR REPLACE INTO cities (id, name, disable, topPick)
        VALUES (?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(city.id))
            sqlite3_bind_text(statement, 2, (city.name as NSString).utf8String, -1, nil)
            
            if let disable = city.disable {
                sqlite3_bind_text(statement, 3, (disable as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 3)
            }
            
            sqlite3_bind_int(statement, 4, Int32(city.topPick))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error saving city: \(city.name)")
            }
        } else {
            print("Error preparing city statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    private func insertPlace(_ place: Place) {
        let sql = """
        INSERT INTO places (id, title, coverPhoto, descriptionText, viewsNo, likesNo, recommended, 
                           detailedDescription, address, isLiked, lastUpdated, cityId)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            bindPlaceParameters(statement: statement, place: place)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting place: \(place.title)")
            } else {
                print("✅ Saved place: \(place.title)")
            }
        } else {
            print("Error preparing insert statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    func updatePlace(_ place: Place) {
        let sql = """
        UPDATE places SET 
            title = ?, coverPhoto = ?, descriptionText = ?, viewsNo = ?, likesNo = ?, 
            recommended = ?, detailedDescription = ?, address = ?, isLiked = ?, 
            lastUpdated = ?, cityId = ?
        WHERE id = ?;
        """
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            bindPlaceParameters(statement: statement, place: place)
            sqlite3_bind_text(statement, 12, (place.id as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating place: \(place.title)")
            } else {
                print("🔄 Updated place: \(place.title)")
            }
        } else {
            print("Error preparing update statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    private func bindPlaceParameters(statement: OpaquePointer?, place: Place) {
        sqlite3_bind_text(statement, 1, (place.id as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (place.title as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (place.coverPhoto as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 4, (place.description as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 5, Int32(place.viewsNo))
        sqlite3_bind_int(statement, 6, Int32(place.likesNo))
        sqlite3_bind_int(statement, 7, Int32(place.recommended))
        sqlite3_bind_text(statement, 8, (place.detailedDescription as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 9, (place.address as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 10, (place.isLiked ?? false) ? 1 : 0)
        sqlite3_bind_double(statement, 11, Date().timeIntervalSince1970)
        sqlite3_bind_int(statement, 12, Int32(place.city.id))
    }
    
    // MARK: - Fetch Operations
    func fetchAllPlaces() -> [Place] {
        let sql = """
        SELECT p.*, c.id as city_id, c.name as city_name, c.disable as city_disable, c.topPick as city_topPick
        FROM places p
        JOIN cities c ON p.cityId = c.id;
        """
        
        var statement: OpaquePointer?
        var places: [Place] = []
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let place = parsePlace(from: statement) {
                    places.append(place)
                }
            }
        } else {
            print("Error preparing fetch all statement")
        }
        
        sqlite3_finalize(statement)
        print("📋 Fetched \(places.count) places from database")
        return places
    }
    
    func fetchPlace(by id: String) -> Place? {
        let sql = """
        SELECT p.*, c.id as city_id, c.name as city_name, c.disable as city_disable, c.topPick as city_topPick
        FROM places p
        JOIN cities c ON p.cityId = c.id
        WHERE p.id = ?;
        """
        
        var statement: OpaquePointer?
        var place: Place?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                place = parsePlace(from: statement)
            }
        } else {
            print("Error preparing fetch by id statement")
        }
        
        sqlite3_finalize(statement)
        return place
    }
    
    func fetchRecommendedPlaces() -> [Place] {
        let sql = """
        SELECT p.*, c.id as city_id, c.name as city_name, c.disable as city_disable, c.topPick as city_topPick
        FROM places p
        JOIN cities c ON p.cityId = c.id
        WHERE p.recommended = 1;
        """
        
        var statement: OpaquePointer?
        var places: [Place] = []
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let place = parsePlace(from: statement) {
                    places.append(place)
                }
            }
        } else {
            print("Error preparing fetch recommended statement")
        }
        
        sqlite3_finalize(statement)
        print("⭐ Fetched \(places.count) recommended places")
        return places
    }
    
    func searchPlacesByTitle(_ searchWord: String) -> [Place] {
        let sql = """
        SELECT p.*, c.id as city_id, c.name as city_name, c.disable as city_disable, c.topPick as city_topPick
        FROM places p
        JOIN cities c ON p.cityId = c.id
        WHERE LOWER(p.title) LIKE LOWER(?);
        """
        
        var statement: OpaquePointer?
        var places: [Place] = []
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            let searchPattern = "%\(searchWord)%"
            sqlite3_bind_text(statement, 1, (searchPattern as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                if let place = parsePlace(from: statement) {
                    places.append(place)
                }
            }
        }
        
        sqlite3_finalize(statement)
        return places
    }
    
    private func parsePlace(from statement: OpaquePointer?) -> Place? {
        guard let statement = statement else { return nil }
        
        // Get place data
        guard let id = sqlite3_column_text(statement, 0),
              let title = sqlite3_column_text(statement, 1),
              let coverPhoto = sqlite3_column_text(statement, 2),
              let descriptionText = sqlite3_column_text(statement, 3),
              let detailedDescription = sqlite3_column_text(statement, 7),
              let address = sqlite3_column_text(statement, 8),
              let cityName = sqlite3_column_text(statement, 13) else {
            return nil
        }
        
        let viewsNo = Int(sqlite3_column_int(statement, 4))
        let likesNo = Int(sqlite3_column_int(statement, 5))
        let recommended = Int(sqlite3_column_int(statement, 6))
        let isLiked = sqlite3_column_int(statement, 9) == 1
        
        // City data
        let cityId = Int(sqlite3_column_int(statement, 12))
        
        let cityDisable: String?
        if let disableText = sqlite3_column_text(statement, 14) {
            cityDisable = String(cString: disableText)
        } else {
            cityDisable = nil
        }
        
        let cityTopPick = Int(sqlite3_column_int(statement, 15))
        
        let city = City(
            id: cityId,
            name: String(cString: cityName),
            disable: cityDisable,
            topPick: cityTopPick
        )
        
        return Place(
            id: String(cString: id),
            title: String(cString: title),
            coverPhoto: String(cString: coverPhoto),
            description: String(cString: descriptionText),
            viewsNo: viewsNo,
            likesNo: likesNo,
            recommended: recommended,
            city: city,
            detailedDescription: String(cString: detailedDescription),
            address: String(cString: address),
            isLiked: isLiked
        )
    }
    
    // MARK: - Update Operations
    func likePlace(placeId: String, likeCount: Int) {
        let sql = "UPDATE places SET isLiked = 1, likesNo = ? WHERE id = ?;"
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            //sqlite3_bind_double(statement, 1, Date().timeIntervalSince1970)  // Parameter 1: lastUpdated
            sqlite3_bind_int(statement, 1, Int32(likeCount))                 // Parameter 2: likesNo
            sqlite3_bind_text(statement, 2, (placeId as NSString).utf8String, -1, nil) // Parameter 3: id
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error toggling like for place: \(placeId)")
            } else {
                print("🔄 Toggled like for place: \(placeId)")
            }
        } else {
            print("Error preparing toggle like statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    // MARK: - Delete Operations
    func deletePlace(placeId: String) {
        let sql = "DELETE FROM places WHERE id = ?;"
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (placeId as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error deleting place: \(placeId)")
            } else {
                print("🗑️ Deleted place: \(placeId)")
            }
        } else {
            print("Error preparing delete statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteAllPlaces() {
        executeSQL("DELETE FROM places;")
        executeSQL("DELETE FROM cities;")
        print("🧹 Deleted all places and cities")
    }
}
