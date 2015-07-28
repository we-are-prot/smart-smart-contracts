contract Perceptron {
    int256[][] public training_data;
    bool[] public target_decisions;
    int256[] public weights;
    int256 threshold = 0;
    event Log(int256, int256);
  
    function dotProduct(int[] w,int[] x) returns (int ret) {
        /*
        dotProduct([1,2,3,4],[5,6,7,8]) => 70
        */
        
        ret = 0;
        for (uint i = 0; i < w.length; i++){
            int256 _w = w[i];
            int256 _x = x[i];
            ret += _w * _x;
        }        
    }
    
    function decide(int256[] data) returns (bool) {
        /*
        decide([1,2,3,4],[5,6,7,8]) => true
        decide([1,2,3,4],[5,6,7,8]) => false
        */
        
        int256 dp = 0;
        uint len = data.length;
        uint i = 0;
        for (i = 0; i < len; i++){
            dp = dp + (data[i] * weights[i]);
        }
        if (dp > threshold) {
            return true;
        }
        return false;
    }
    
    function addTrainingItem(int256[] data, bool target) returns (int[]) {
        /* 
        addTrainingItem([1], true);
        addTrainingItem([15], false);
        */
        
        training_data[training_data.length++] = data;
        target_decisions[target_decisions.length++] = target;
        weights.length = data.length;
        return weights;
    }

    function getTrainingItem(uint i) returns (int256[] data, bool target) {
        data = training_data[i];
        target = target_decisions[i];
    }
    
    function getWeights() returns (int256[]) {
        return weights;
    }
  
    function learn(uint max_iterations) {
        bool converged = false;
        int256 threshold = 0;
        int256 last_threshold = 0;		
        for (uint i = 0; i < max_iterations; i++) {
            threshold = learnOnce();
            Log(4, threshold);
        }
    }
  
    function learnOnce() returns (int256 ret){	
        for (uint j = 0; j < training_data.length; j++) {
            int256[] memory data = training_data[j];
            bool target_decision = target_decisions[j];
            bool decision = decide(data);
            if (decision == target_decision) {
                // continue   
            } else {
                if (decision == false 
                && target_decision == true) {
                    threshold -= 1;
                    for (var k = 0; k < data.length; k++) {
                        weights[k] += data[k];
                    }
                } else {
                    if (decision == true && target_decision == false) {
                        threshold += 1;
                        for (var l = 0; l < data.length; l++) {
                            weights[l] -= data[l];
                        } 							
                    }
                }
            }
        }
        ret = threshold;
    }
}
