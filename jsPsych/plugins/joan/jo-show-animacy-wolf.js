/*
 * Example plugin template
 */

jsPsych.plugins["jo-show-animacy-wolf"] = (function() {

  var plugin = {};

  plugin.info = {
    name: "jo-show-animacy-wolf",
    parameters: {
      trial_id: {
        type: jsPsych.plugins.parameterType.INT, // BOOL, STRING, INT, FLOAT, FUNCTION, KEYCODE, SELECT, HTML_STRING, IMAGE, AUDIO, VIDEO, OBJECT, COMPLEX
        default: 1
      },
      condition: {
        type: jsPsych.plugins.parameterType.STRING, // BOOL, STRING, INT, FLOAT, FUNCTION, KEYCODE, SELECT, HTML_STRING, IMAGE, AUDIO, VIDEO, OBJECT, COMPLEX
        default: "chase"
      },
      give_feedback: {
        type: jsPsych.plugins.parameterType.BOOL, // BOOL, STRING, INT, FLOAT, FUNCTION, KEYCODE, SELECT, HTML_STRING, IMAGE, AUDIO, VIDEO, OBJECT, COMPLEX
        default: false
      },
    }
  }

  plugin.trial = function(display_element, trial) {
    // Setup parameters
    var canvas_w = window.innerWidth*.8;
    var canvas_h = window.innerHeight*.8;

    // Draw canvas
    document.body.style.cursor = 'none';
    display_element.innerHTML = "<div style='text-align:center; margin: 0 auto'>"+"<canvas style='border-color: black; border-style:solid; background-color:grey' id='myCanvas' width='"+canvas_w+"' height='"+canvas_h+"'></canvas>"+"</div>";
    var canvas = display_element.querySelector('#myCanvas');
    var context = canvas.getContext('2d');

    // Get path coordinates
    if (trial.condition=='chase'){
      var wolfXpos = wolfX[trial.trial_id];
      var wolfYpos = wolfY[trial.trial_id];
      var sheepXpos = sheepX[trial.trial_id];
      var sheepYpos = sheepY[trial.trial_id];
      var dist1Xpos = dist1X[trial.trial_id];
      var dist1Ypos = dist1Y[trial.trial_id];
      var dist2Xpos = dist2X[trial.trial_id];
      var dist2Ypos = dist2Y[trial.trial_id];
      var dist3Xpos = dist3X[trial.trial_id];
      var dist3Ypos = dist3Y[trial.trial_id];
      var dist4Xpos = dist4X[trial.trial_id];
      var dist4Ypos = dist4Y[trial.trial_id];
      var dist5Xpos = dist5X[trial.trial_id];
      var dist5Ypos = dist5Y[trial.trial_id];
      var dist6Xpos = dist6X[trial.trial_id];
      var dist6Ypos = dist6Y[trial.trial_id];
    } else if (trial.condition=='mirror'){
      var wolfXpos = mwolfX[trial.trial_id];
      var wolfYpos = mwolfY[trial.trial_id];
      var sheepXpos = msheepX[trial.trial_id];
      var sheepYpos = msheepY[trial.trial_id];
      var dist1Xpos = mdist1X[trial.trial_id];
      var dist1Ypos = mdist1Y[trial.trial_id];
      var dist2Xpos = mdist2X[trial.trial_id];
      var dist2Ypos = mdist2Y[trial.trial_id];
      var dist3Xpos = mdist3X[trial.trial_id];
      var dist3Ypos = mdist3Y[trial.trial_id];
      var dist4Xpos = mdist4X[trial.trial_id];
      var dist4Ypos = mdist4Y[trial.trial_id];
      var dist5Xpos = mdist5X[trial.trial_id];
      var dist5Ypos = mdist5Y[trial.trial_id];
      var dist6Xpos = mdist6X[trial.trial_id];
      var dist6Ypos = mdist6Y[trial.trial_id];
    }

    var radius = window.innerWidth*.01;
    var num_frames = 120;
    var displace_x = canvas_w/2;
    var displace_y = canvas_h/2;

    var get_pos_wolf;
    var get_pos_sheep;
    var get_pos_dist1;
    var get_pos_dist2;
    var get_pos_dist3;
    var get_pos_dist4;
    var get_pos_dist5;
    var get_pos_dist6;

    function draw_discs(percent_time){
      which_frame = parseInt(percent_time*num_frames);
    
      get_pos_wolf = [displace_x - wolfXpos[parseInt(which_frame)], displace_y - wolfYpos[parseInt(which_frame)]];
      path_color = "white";
      context.beginPath();
      context.arc(get_pos_wolf[0], get_pos_wolf[1], radius, 0, 2 * Math.PI, false);
      context.fillStyle = path_color;
      context.fill();
      context.closePath();

      get_pos_sheep = [displace_x - sheepXpos[parseInt(which_frame)], displace_y - sheepYpos[parseInt(which_frame)]];
      path_color = "white";
      context.beginPath();
      context.arc(get_pos_sheep[0], get_pos_sheep[1], radius, 0, 2 * Math.PI, false);
      context.fillStyle = path_color;
      context.fill();
      context.closePath();

      get_pos_dist1 = [displace_x - dist1Xpos[parseInt(which_frame)], displace_y - dist1Ypos[parseInt(which_frame)]];
      path_color = "white";
      context.beginPath();
      context.arc(get_pos_dist1[0], get_pos_dist1[1], radius, 0, 2 * Math.PI, false);
      context.fillStyle = path_color;
      context.fill();
      context.closePath();

      get_pos_dist2 = [displace_x - dist2Xpos[parseInt(which_frame)], displace_y - dist2Ypos[parseInt(which_frame)]];
      path_color = "white";
      context.beginPath();
      context.arc(get_pos_dist2[0], get_pos_dist2[1], radius, 0, 2 * Math.PI, false);
      context.fillStyle = path_color;
      context.fill();
      context.closePath();

      get_pos_dist3 = [displace_x - dist3Xpos[parseInt(which_frame)], displace_y - dist3Ypos[parseInt(which_frame)]];
      path_color = "white";
      context.beginPath();
      context.arc(get_pos_dist3[0], get_pos_dist3[1], radius, 0, 2 * Math.PI, false);
      context.fillStyle = path_color;
      context.fill();
      context.closePath();

      get_pos_dist4 = [displace_x - dist4Xpos[parseInt(which_frame)], displace_y - dist4Ypos[parseInt(which_frame)]];
      path_color = "white";
      context.beginPath();
      context.arc(get_pos_dist4[0], get_pos_dist4[1], radius, 0, 2 * Math.PI, false);
      context.fillStyle = path_color;
      context.fill();
      context.closePath();

      get_pos_dist5 = [displace_x - dist5Xpos[parseInt(which_frame)], displace_y - dist5Ypos[parseInt(which_frame)]];
      path_color = "white";
      context.beginPath();
      context.arc(get_pos_dist5[0], get_pos_dist5[1], radius, 0, 2 * Math.PI, false);
      context.fillStyle = path_color;
      context.fill();
      context.closePath();

      get_pos_dist6 = [displace_x - dist6Xpos[parseInt(which_frame)], displace_y - dist6Ypos[parseInt(which_frame)]];
      path_color = "white";
      context.beginPath();
      context.arc(get_pos_dist6[0], get_pos_dist6[1], radius, 0, 2 * Math.PI, false);
      context.fillStyle = path_color;
      context.fill();
      context.closePath();
    }

    var current_time = 0;
    var start_time = performance.now();
    var trial_duration = 4;

    function animate_path(){
      current_time = performance.now();
      time_elapsed = parseFloat(current_time - start_time)/1000;
      percent_time = time_elapsed / parseFloat(trial_duration);
      
      context.clearRect(0, 0, canvas_w, canvas_h);

      draw_discs(percent_time);

      myReq = requestAnimationFrame(function(){animate_path()});

      if (parseInt(percent_time*num_frames) >= 120){
        context.clearRect(0, 0, canvas_w, canvas_h);
        draw_discs(0.999);
        window.cancelAnimationFrame(myReq);
        document.body.style.cursor = 'auto';
        context.font = "25px Arial";
        context.fillStyle = 'white'
        context.fillText("Click on the disc that looked like it was chasing another disc", 10, 25);
        display_element.querySelector('#myCanvas').addEventListener('click', handleClick, true);
        start_time = performance.now();
      }
    }

    animate_path();

    var canvasOffset = $("#myCanvas").offset();
    var offsetX = canvasOffset.left;
    var offsetY = canvasOffset.top;
    var scrollX = $("#myCanvas").scrollLeft();
    var scrollY = $("#myCanvas").scrollTop();
    var mouseX;
    var mouseY;
    var num_click = 0;
    var rt = 0;
    var selectedDisc;
    var confidence = 0;
    function handleClick(e){
      e.preventDefault();
      mouseX = parseInt(e.clientX - offsetX);
      mouseY = parseInt(e.clientY - offsetY);

      if (inside_circle(mouseX, mouseY, get_pos_wolf[0], get_pos_wolf[1], radius)){
        path_color = "white";
        context.beginPath();
        context.arc(get_pos_wolf[0], get_pos_wolf[1], radius, 0, 2 * Math.PI, false);
        context.fillStyle = path_color;
        context.fill();
        context.strokeStyle = 'purple';
        context.lineWidth = 3;
        context.stroke();
        context.closePath();
        num_click = 1;
        rt = performance.now() - start_time;
        selectedDisc = 'wolf'
      }
      if (inside_circle(mouseX, mouseY, get_pos_sheep[0], get_pos_sheep[1], radius)){
        path_color = "white";
        context.beginPath();
        context.arc(get_pos_sheep[0], get_pos_sheep[1], radius, 0, 2 * Math.PI, false);
        context.fillStyle = path_color;
        context.fill();
        context.strokeStyle = 'purple';
        context.lineWidth = 3;
        context.stroke();
        context.closePath();
        num_click = 1;
        rt = performance.now() - start_time;
        selectedDisc = 'sheep'
      }
      if (inside_circle(mouseX, mouseY, get_pos_dist1[0], get_pos_dist1[1], radius)){
        path_color = "white";
        context.beginPath();
        context.arc(get_pos_dist1[0], get_pos_dist1[1], radius, 0, 2 * Math.PI, false);
        context.fillStyle = path_color;
        context.fill();
        context.strokeStyle = 'purple';
        context.lineWidth = 3;
        context.stroke();
        context.closePath();
        num_click = 1;
        rt = performance.now() - start_time;
        selectedDisc = 'dist1'
      }
      if (inside_circle(mouseX, mouseY, get_pos_dist2[0], get_pos_dist2[1], radius)){
        path_color = "white";
        context.beginPath();
        context.arc(get_pos_dist2[0], get_pos_dist2[1], radius, 0, 2 * Math.PI, false);
        context.fillStyle = path_color;
        context.fill();
        context.strokeStyle = 'purple';
        context.lineWidth = 3;
        context.stroke();
        context.closePath();
        num_click = 1;
        rt = performance.now() - start_time;
        selectedDisc = 'dist2'
      }
      if (inside_circle(mouseX, mouseY, get_pos_dist3[0], get_pos_dist3[1], radius)){
        path_color = "white";
        context.beginPath();
        context.arc(get_pos_dist3[0], get_pos_dist3[1], radius, 0, 2 * Math.PI, false);
        context.fillStyle = path_color;
        context.fill();
        context.strokeStyle = 'purple';
        context.lineWidth = 3;
        context.stroke();
        context.closePath();
        num_click = 1;
        rt = performance.now() - start_time;
        selectedDisc = 'dist3'
      }
      if (inside_circle(mouseX, mouseY, get_pos_dist4[0], get_pos_dist4[1], radius)){
        path_color = "white";
        context.beginPath();
        context.arc(get_pos_dist4[0], get_pos_dist4[1], radius, 0, 2 * Math.PI, false);
        context.fillStyle = path_color;
        context.fill();
        context.strokeStyle = 'purple';
        context.lineWidth = 3;
        context.stroke();
        context.closePath();
        num_click = 1;
        rt = performance.now() - start_time;
        selectedDisc = 'dist4'
      } 
      if (inside_circle(mouseX, mouseY, get_pos_dist5[0], get_pos_dist5[1], radius)){
        path_color = "white";
        context.beginPath();
        context.arc(get_pos_dist5[0], get_pos_dist5[1], radius, 0, 2 * Math.PI, false);
        context.fillStyle = path_color;
        context.fill();
        context.strokeStyle = 'purple';
        context.lineWidth = 3;
        context.stroke();
        context.closePath();
        num_click = 1;
        rt = performance.now() - start_time;
        selectedDisc = 'dist5'
      }
      if (inside_circle(mouseX, mouseY, get_pos_dist6[0], get_pos_dist6[1], radius)){
        path_color = "white";
        context.beginPath();
        context.arc(get_pos_dist6[0], get_pos_dist6[1], radius, 0, 2 * Math.PI, false);
        context.fillStyle = path_color;
        context.fill();
        context.strokeStyle = 'purple';
        context.lineWidth = 3;
        context.stroke();
        context.closePath();
        num_click = 1;
        rt = performance.now() - start_time;
        selectedDisc = 'dist6'
      }  

      if (num_click == 1){
        display_element.querySelector('#myCanvas').removeEventListener('click', handleClick, true);
        context.fillStyle = 'white';
        context.fillText("How confident were you in your response? (Press 1 = Not at all; 5 = I'm sure of it!)", 10, 85);
        document.addEventListener('keypress', checkResponse);
        function checkResponse(evt){
          if (evt.key == '1' | evt.key == '2' | evt.key == '3' | evt.key == '4' | evt.key == '5'){
            confidence = evt.key;
            document.removeEventListener('keypress', checkResponse);
            setTimeout(function(){ end_trial();}, 500)
          }
        }
      }

    }

    function inside_circle(x, y, cx, cy, r) {
        var dx = x - cx
        var dy = y - cy
        return dx*dx + dy*dy <= r*r
    }

    function end_trial(){

      time = 0; 

      if (trial.give_feedback){
        context.font = "25px Arial";
        context.fillStyle = 'white'
        context.fillText("The disc highlighted in green is the correct answer!", 10, 625);
        path_color = "white";
        context.beginPath();
        context.arc(get_pos_wolf[0], get_pos_wolf[1], radius, 0, 2 * Math.PI, false);
        context.fillStyle = path_color;
        context.fill();
        context.strokeStyle = 'green';
        context.lineWidth = 10;
        context.stroke();
        context.closePath();
        time = 2000
      }


      setTimeout(function(){
        // data saving
        var trial_data = {
          trial_id: trial.trial_id,
          condition: trial.condition,
          mouseX: mouseX,
          mouseY: mouseY,
          rt: rt,
          selected: selectedDisc,
          confidence: confidence
        };

        // end trial
        jsPsych.finishTrial(trial_data);

      }, time)
    }

  };

  return plugin;
})();
