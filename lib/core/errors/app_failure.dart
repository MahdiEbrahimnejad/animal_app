/// Result of operations that may fail without crashing the app.
enum PurchaseResult { success, pending, cancelled, failed, unavailable }

enum RestoreResult { restored, nothingToRestore, failed, unavailable }
