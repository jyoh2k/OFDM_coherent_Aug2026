% .fig에 저장된 콜백이 이 이름을 호출하므로 CO_OFDM으로 넘깁니다.
% GUI 실행은 CO_OFDM을 사용하세요.
function varargout = TeraHertz_OFDM(varargin)
[varargout{1:nargout}] = CO_OFDM(varargin{:});
