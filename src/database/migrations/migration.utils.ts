/**
 * Migration Utility Helper Functions.
 */
export class MigrationUtils {
  /**
   * Generates standard timestamped migration name prefix (YYYYMMDDHHMMSS).
   */
  static generateMigrationTimestamp(): string {
    const now = new Date();
    const pad = (n: number) => String(n).padStart(2, '0');
    return (
      `${now.getFullYear()}` +
      `${pad(now.getMonth() + 1)}` +
      `${pad(now.getDate())}` +
      `${pad(now.getHours())}` +
      `${pad(now.getMinutes())}` +
      `${pad(now.getSeconds())}`
    );
  }

  /**
   * Constructs migration class name following standard conventions (`Create[Entity]Table[Timestamp]`).
   */
  static formatMigrationClassName(name: string, timestamp: string): string {
    const sanitized = name.replace(/[^a-zA-Z0-9]/g, '');
    const capitalized = sanitized.charAt(0).toUpperCase() + sanitized.slice(1);
    return `${capitalized}${timestamp}`;
  }
}
