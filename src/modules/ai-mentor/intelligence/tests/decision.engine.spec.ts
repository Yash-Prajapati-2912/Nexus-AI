import { DecisionEngine } from '../engines/decision.engine';
import { IAIMentorContext } from '../../interfaces/ai-mentor-context.interface';

describe('DecisionEngine', () => {
  let engine: DecisionEngine;

  beforeEach(() => {
    engine = new DecisionEngine();
  });

  it('should analyze decision query and provide trade-offs and opportunity cost', () => {
    const mockContext: IAIMentorContext = { userId: 'usr-1' };
    const query = 'Should I accept a full-time remote internship?';

    const res = engine.analyzeDecision(mockContext, query);

    expect(res.decisionTitle).toBe(query);
    expect(res.pros.length).toBeGreaterThan(0);
    expect(res.cons.length).toBeGreaterThan(0);
    expect(res.opportunityCost).toBeDefined();
    expect(res.confidenceScore).toBe(0.92);
  });
});
