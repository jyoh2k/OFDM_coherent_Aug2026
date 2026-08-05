
function default_colorw(handlesf)
  if ( ~isempty(handlesf)   && ishandle(handlesf) )
    set(handlesf, 'Color', [ 1 1 1]);
    set(handlesf, 'AmbientLightColor', [ 0 0 0]);
%     set(handlesf, 'GridColor', [ 1 1 1  ]);  
    set(handlesf, 'XColor', [ 0 0 0]);
    set(handlesf, 'YColor', [ 0 0 0]);
   % set(handlesf, 'XTick', [ ]);
   % set(handlesf, 'YTick', [ ]);
end
