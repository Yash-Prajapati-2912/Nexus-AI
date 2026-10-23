import { CareerEngine } from '../engines/career.engine';
import { IAIMentorContext } from '../../interfaces/ai-mentor-context.interface';
import { ReadinessLevel } from '../constants/intelligence-enums.constants';

describe('CareerEngine', () => {
  let engine: CareerEngine;

  beforeEach(() => {
    engine = new CareerEngine();
  });

  it('should analyze career readiness and identify skill gaps', () => {
    const mockContext: IAIMentorContext = {
      userId: 'usr-1',
      userProfile: {
        skills: ['TypeScript', 'Node.js', 'PostgreSQL'],
        careerGoals: ['Software Engineer'],
      },
    };

    const res = engine.analyzeCareerReadiness(mockContext, 'Software Engineer');

    expect(res.targetRole).toBe('Software Engineer');
    expect(res.skillGaps).toContain('docker');
    expect(res.skillGaps).toContain('git');
    expect(res.readinessScore).toBe(60);
    expect(res.readinessLevel).toBe(ReadinessLevel.ADVANCED);
    expect(res.milestones.length).toBe(3);
  });
});
