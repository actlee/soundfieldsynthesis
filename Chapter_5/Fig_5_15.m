%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This work is supplementary material for the book                        %
%                                                                         %
% Jens Ahrens, Analytic Methods of Sound Field Synthesis, Springer-Verlag %
% Berlin Heidelberg, 2012, http://dx.doi.org/10.1007/978-3-642-25743-8    %
%                                                                         %
% It has been downloaded from http://soundfieldsynthesis.org and is       %
% licensed under a Creative Commons Attribution-NonCommercial-ShareAlike  %
% 3.0 Unported License. Please cite the book appropriately if you use     %
% these materials in your own work.                                       %
%                                                                         %
% (c) 2012 by Jens Ahrens                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

subfigure = 'a';  % for Fig. 5.15(a) 
%subfigure = 'b';  % for Fig. 5.15(b)
%subfigure = 'c';  % for Fig. 5.15(c)
%subfigure = 'd';  % for Fig. 5.15(d)
%subfigure = 'e';  % for Fig. 5.15(e)
%subfigure = 'f';  % for Fig. 5.15(f)

if ( subfigure == 'a' || subfigure == 'c' || subfigure == 'e'  )
    M = 27;
    
else
    M = 79;
    
end

if ( subfigure == 'a' || subfigure == 'b' )
    f = 1000;
    
elseif ( subfigure == 'c' || subfigure == 'd' )
    f = 2000;
    
elseif ( subfigure == 'e' || subfigure == 'f' )
    f = 5000;
    
end

r_s      = 3;
alpha_s  = -pi/2;
L        = 56;
R        = 1.5;
c        = 343;
k        = 2*pi*f/c;

% spatial sampling grid
alpha_0 = linspace( 0, 2*pi, L+1 );
alpha_0 = alpha_0( 1 : end-1 );
beta_0  = pi/2;

% create spatial grid
X        = linspace( -2, 2, 300 );
Y        = linspace( -2, 2, 300 );
[ x, y ] = meshgrid( X, Y );

% initialize variables
S       = zeros( size( x ) );
G_breve = zeros( 2*M+1, 1 );
S_breve = zeros( 2*M+1, 1 );

for m = -M : M
    % Eq. (2.37a)
    G_breve( m+M+1 ) = -1i .* k .* sphbesselh( abs(m), 2, k.*R ) .* sphharm( abs(m), -m, pi/2, 0 );       
    
    % Eq. (2.37a)
    S_breve( m+M+1 ) = -1i .* k .* sphbesselh( abs(m), 2, k.*r_s ) .* sphharm( abs(m), -m, pi/2, alpha_s );  
    
end

% loop over secondary sources
for l = 1 : L

    % initialize D
    D = 0;

    % this loop evaluates Eq. (3.49)
    for m = -M : M    
        D = D + 1 / ( 2*pi*R ) .* S_breve( m+M+1 ) ./ G_breve( m+M+1 ) .* exp( 1i * m* alpha_0( l ) );                
    end

    % position of secondary source
    x_0 = R * cos( alpha_0( l ) ) * sin( beta_0 );
    y_0 = R * sin( alpha_0( l ) ) * sin( beta_0 );
    z_0 = 0;

    S = S + D .* point_source( x, y, x_0, y_0, z_0, k );

end

% normalize 
S = S ./ abs( S( end/2, end/2 ) );

figure;

imagesc( X, Y, real( S ), [ -2 2 ] );
turn_imagesc;
colormap gray;
axis square;
hold on;

% plot secondary source distribution
plot( R * cos( alpha_0 ), R * sin( alpha_0 ), 'kx' )

if ( subfigure == 'c' || subfigure == 'e' )
    % plot r_M region, Eq. (2.41)
    r_limit = M/k;
    x_circ = linspace( -r_limit, r_limit, 100 );
    
    plot( x_circ,  sqrt( r_limit.^2 - x_circ.^2 ), 'k:', 'LineWidth', 2 )
    plot( x_circ, -sqrt( r_limit.^2 - x_circ.^2 ), 'k:', 'LineWidth', 2 )
    
end

hold off;

xlabel( 'x (m)' );
ylabel( 'y (m)' );

graph_defaults;
