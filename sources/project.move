module MyModule::DiseaseOutbreakTracking {
    use aptos_framework::signer;
    use aptos_framework::timestamp;

    /// Struct representing a disease outbreak report.
    struct OutbreakReport has store, key {
        disease_name: vector<u8>,     // Name of the disease
        location: vector<u8>,         // Location of the outbreak
        confirmed_cases: u64,         // Number of confirmed cases
        suspected_cases: u64,         // Number of suspected cases
        deaths: u64,                  // Number of deaths
        report_timestamp: u64,        // Timestamp when reported
        last_updated: u64,            // Timestamp of last update
        is_active: bool,              // Whether outbreak is still active
    }

    /// Function to report a new disease outbreak.
    /// Can only be called by health authorities (account owners).
    public fun report_outbreak(
        authority: &signer, 
        disease_name: vector<u8>,
        location: vector<u8>,
        confirmed_cases: u64,
        suspected_cases: u64,
        deaths: u64
    ) {
        let current_time = timestamp::now_seconds();
        let outbreak_report = OutbreakReport {
            disease_name,
            location,
            confirmed_cases,
            suspected_cases,
            deaths,
            report_timestamp: current_time,
            last_updated: current_time,
            is_active: true,
        };
        move_to(authority, outbreak_report);
    }

    /// Function to update an existing outbreak report with new data.
    /// Updates case numbers and marks outbreak status.
    public fun update_outbreak(
        authority: &signer,
        new_confirmed_cases: u64,
        new_suspected_cases: u64,
        new_deaths: u64,
        is_still_active: bool
    ) acquires OutbreakReport {
        let authority_address = signer::address_of(authority);
        let outbreak_report = borrow_global_mut<OutbreakReport>(authority_address);
        
        // Update the outbreak data
        outbreak_report.confirmed_cases = new_confirmed_cases;
        outbreak_report.suspected_cases = new_suspected_cases;
        outbreak_report.deaths = new_deaths;
        outbreak_report.is_active = is_still_active;
        outbreak_report.last_updated = timestamp::now_seconds();
    }
}