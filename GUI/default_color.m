
function default_color(handlesf)
  if ( ~isempty(handlesf)   && ishandle(handlesf) )
    set(handlesf, 'Color', [ 0 0 0]);
    set(handlesf, 'AmbientLightColor', [ 1 1 1]);
%     set(handlesf, 'GridColor', [ 1 1 1  ]);  
    set(handlesf, 'XColor', [ 1 1 1]);
    set(handlesf, 'YColor', [ 1 1 1]);
   % set(handlesf, 'XTick', [ ]);
   % set(handlesf, 'YTick', [ ]);
end
