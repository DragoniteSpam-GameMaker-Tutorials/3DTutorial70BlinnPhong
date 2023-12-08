/// @description Draw the 3D world

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
draw_clear(c_black);

// 3D projections require a view and projection matrix
var camera = camera_get_active();

var xfrom = Player.x;
var yfrom = Player.y;
var zfrom = Player.z + 64;
var xto = xfrom - dcos(Player.look_dir) * dcos(Player.look_pitch);
var yto = yfrom + dsin(Player.look_dir) * dcos(Player.look_pitch);
var zto = zfrom + dsin(Player.look_pitch);

view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
proj_mat = matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), znear, zfar);
camera_set_view_mat(camera, view_mat);
camera_set_proj_mat(camera, proj_mat);
camera_apply(camera);

var layer_id = layer_get_id("Tiles_1");
layer_set_visible(layer_id, false);
var tilemap_id = layer_tilemap_get_id(layer_id);
draw_tilemap(tilemap_id, 0, 0);

shader_set(shd_basic_3d_stuff);
shader_set_uniform_f(shader_get_uniform(shd_basic_3d_stuff, "u_LightPosition"), 0, 0, 100);
shader_set_uniform_f(shader_get_uniform(shd_basic_3d_stuff, "u_LightRadius"), 500);
shader_set_uniform_f(shader_get_uniform(shd_basic_3d_stuff, "u_ViewPosition"), xfrom, yfrom, zfrom);

matrix_set(matrix_world, matrix_build(250, 250, 40, 0, 0, 0, 1, 1, 1));
vertex_submit(vb_merry, pr_trianglelist, -1);

matrix_set(matrix_world, matrix_build(250, -250, 0, 0, 0, 0, 1, 1, 1));
vertex_submit(vb_sheet, pr_trianglelist, -1);

matrix_set(matrix_world, matrix_build(250, 360, 16, 0, 0, 0, 1, 1, 1));
vertex_submit(vb_sphere, pr_trianglelist, -1);
matrix_set(matrix_world, matrix_build(250, 420, 32, 0, 0, 0, 1, 1, 1));
vertex_submit(vb_sphere, pr_trianglelist, -1);
matrix_set(matrix_world, matrix_build(250, 480, 64, 0, 0, 0, 1, 1, 1));
vertex_submit(vb_sphere, pr_trianglelist, -1);

for (var i = 0, n = array_length(tree_positions); i < n; i++) {
    matrix_set(matrix_world, matrix_build(tree_positions[i].x, tree_positions[i].y, 0, 0, 0, 0, 1, 1, 1));
    vertex_submit(tree_positions[i].vbuff, pr_trianglelist, -1);
}

matrix_set(matrix_world, matrix_build_identity());

shader_reset();

gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);