package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.PlanVO;

public interface PlanService {
	
	//1. 플랜 조회
	public List<Map<String, Object>> planList();
	
	//2. 플랜 등록
	public int insertPlan(PlanVO vo);
	
	//3. 플랜 수정
	public int editPlan(PlanVO vo);
	public int updatePrice(Map<String, Integer>map);
	
	//4. 플랜 삭제
	public int deletePlan(String planId);
	
	//5. 플랜 1개 조회
	public Map<String, Object> planOne(int planId);

}
