/**
 * Utility builder sanitizing prompt inputs against prompt injection and malicious syntax.
 */
export class PromptSanitizerBuilder {
  static sanitizeText(input?: string | null): string {
    if (!input) return '';
    return input
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
      .replace(/<[^>]+>/g, '')
      .replace(/ignore previous instructions/gi, '[filtered_instruction]')
      .replace(/system prompt/gi, '[filtered_prompt]')
      .replace(/system:/gi, 'system_info:')
      .trim();
  }

  static sanitizeArray(arr?: string[] | null): string[] {
    if (!arr || !Array.isArray(arr)) return [];
    return arr.map((item) => PromptSanitizerBuilder.sanitizeText(item)).filter(Boolean);
  }
}
