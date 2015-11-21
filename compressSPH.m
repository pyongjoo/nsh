function B = compressSPH(xData, centers, radii)
% Input:
%   X is data matrix
%   nb is the number of hash bits

% compute distances from centers
dData = distMat( xData , centers );

% compute binary codes for data points
th = repmat( radii' , size( dData , 1 ) , 1 );
bData = zeros( size(dData) );
bData( dData <= th ) = 1;
bData = compactbit(bData);
B = bData;

end

