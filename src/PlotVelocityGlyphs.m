function PlotVelocityGlyphs()
channel = RectCircg2();                % channel geometry
epsilon = 0.01;                       % diffusion parameter
h = 0.1;                              % mesh size

[p,e,t] = initmesh(channel,'hmax',h); % create mesh
A = assema(p,t,1,0,0);                % stiffness matrix

x = p(1,:); 
y = p(2,:);                           % node coordinates

% --- Parameters for glyph plot ---
xmin = -2; xmax = 6;   % domain bounds (match your geometry)
ymin = -2; ymax = 2;
nx = 40; ny = 20;      % grid resolution for glyphs (coarser -> less clutter)
skip = 1;              % further decimation factor (use skip>1 to show fewer arrows)
scale = 0.8;           % quiver autoscale factor (tune visually)

% Create a regular grid for glyph placement
[X, Y] = meshgrid(linspace(xmin, xmax, nx), linspace(ymin, ymax, ny));

% Evaluate the velocity field on that grid (FlowField must accept matrices)
[BX, BY] = FlowField2(X, Y);

% Mask points that lie inside either cylinder (so arrows are not drawn inside holes)
r1 = sqrt((X-0).^2 + (Y-0).^2) <= 1;    % cylinder 1 (center (0,0), radius 1)
r2 = sqrt((X-4).^2 + (Y-0).^2) <= 1;    % cylinder 2 (center (4,0), radius 1)
mask = r1 | r2;
BX(mask) = NaN; BY(mask) = NaN;         % quiver ignores NaN entries

% Decimate (optional) to reduce clutter
Xs = X(1:skip:end, 1:skip:end);
Ys = Y(1:skip:end, 1:skip:end);
Bxs = BX(1:skip:end, 1:skip:end);
Bys = BY(1:skip:end, 1:skip:end);

% Plot background (optional): FEM scalar field U from your solver
figure;
if exist('p','var') && exist('t','var') && exist('U','var')
    pdeplot(p,e,t, 'XYData', U, 'Contour', 'on', 'ColorBar', 'on', 'Mesh', 'off');
    hold on;
else
    % otherwise draw domain outline for context
    axis([xmin xmax ymin ymax]); hold on;
    axis equal; box on;
end

% Draw vector glyphs
h = quiver(Xs, Ys, Bxs, Bys, scale, 'LineWidth', 1.0);
set(h, 'MaxHeadSize', 1.2);
colormap(parula);

% Optionally show arrow color by magnitude: draw small colored dots at arrow tails
M = sqrt(Bxs.^2 + Bys.^2);
scatter(Xs(:), Ys(:), 15, M(:), 'filled');    % colorbar shows speed
cb = colorbar;
cb.Label.String = 'Speed |b|';
axis equal;
