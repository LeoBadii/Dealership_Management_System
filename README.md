# Dealership Management System

## System Functionality
This project involves the design and implementation of a robust database for a **Tuscan Dealership Chain**. The system is designed to manage high-volume data related to sales, vehicle inventory, and multi-location staffing[cite: 1].

**Key Features:**
*   **Inventory Management:** Tracks both new and used vehicles, including technical specs like horsepower (CV), fuel type, and price[cite: 1].
*   **Staff Hierarchy:** Distinguishes between **Salespeople** (performance-based commissions) and **Directors** (branch management with 10-year certifications)[cite: 1].
*   **Sales & Contracts:** An automated system for recording contracts linking vehicles, customers, and employees[cite: 1].
*   **Test Drives:** A booking system with safety logic to prevent novice drivers from testing high-powered vehicles (> 95 CV)[cite: 1].

## Design & Logic
To ensure data integrity and system efficiency, the following logic was applied:
*   **Reification:** Complex relationships (Test Drives and Contracts) were transformed into independent entities to allow for multiple interactions between the same customer and vehicle[cite: 1].
*   **Redundancy Optimization:** Added derived attributes to the "Dealership" entity (e.g., `Revenue`, `Car_Count`) to speed up frequent analytical queries[cite: 1].
*   **Relational Mapping:** Conversion from a conceptual E-R model to a normalized relational schema[cite: 1].

---

## E-R Model
The system architecture was designed following standard Entity-Relationship conventions to ensure clear data flow[cite: 1].
> **Note:** The diagram illustrates the 1:N and N:M relationships between branches, employees, and stock. Key entities like **Contract** act as the central hub for sales operations[cite: 1].

---

## Implementation Details

### Automated Business Logic (Triggers)
The database utilizes **MySQL Triggers** to enforce business rules that cannot be captured by simple table constraints:
*   **Safety Constraints:** Automatically blocks test drive entries if the customer has held their license for less than 3 years and the car exceeds 95 CV[cite: 1].
*   **Certification Monitoring:** Prevents a Director from being assigned if their professional certification is over 10 years old[cite: 1].
*   **Real-time Statistics:** Triggers update the `Revenue` and inventory counts automatically whenever a sale is finalized[cite: 1].

### Performance Engineering
To handle a scale of **10,000+ vehicles** and **25,000+ customers**, we implemented:
*   **Strategic Redundancy:** Storing the total number of staff and cars in the Dealership table reduces expensive `COUNT` operations during high-traffic reads[cite: 1].
*   **Integrity Checks:** Triggers ensure an employee cannot hold conflicting roles (e.g., Director and Salesperson) simultaneously[cite: 1].

### Procedures & Functions
To simplify complex operations, the system includes:
*   **SpostaAuto:** Handles the logistical transfer of vehicles between different dealership locations[cite: 1].
*   **VendiAuto:** Registers a sale, updates the car status to "Sold," and recalculates dealership revenue in one transaction[cite: 1].

---

## Testing & Quality Assurance
The database logic was verified through workload simulations and edge-case testing:
*   **Integrity Testing:** Verified that deleted personnel records correctly update "Past Affiliation" logs[cite: 1].
*   **Stress Testing:** Analyzed query response times for "Cars in Budget" searches across a large simulated dataset[cite: 1].
*   **Constraint Verification:** Confirmed that horsepower/license-age triggers effectively block unsafe test drive operations[cite: 1].

---

## Technical Stack
*   **Database Engine:** MySQL[cite: 1]
*   **Design Tools:** yED Live / E-R Modeling software[cite: 1]
*   **Documentation:** Markdown / GitHub[cite: 1]
