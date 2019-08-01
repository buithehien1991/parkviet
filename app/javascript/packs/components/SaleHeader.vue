<template>
    <nav class="navbar navbar-expand-lg navbar-dark bg-park">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <form class="form col-md-5">
                <div class="input-group">
                    <div class="input-group-prepend">
                      <span class="input-group-text bg-white border-right-0">
                        <i class="fa fa-search"></i>
                      </span>
                    </div>
                    <input type="text" class="form-control form-control-sm border-left-0" placeholder="Nhập mã hoặc tên mặt hàng (F3)" aria-label="Tìm mặt hàng" id="search-product-input" autofocus>
                </div>
            </form>

            <ul class="navbar-nav mx-auto">
                <div class="d-flex justify-content-center help-text-login">
                    <a class="help-text-login" @click="openReport">Báo cáo</a>
                    <span class="help-text-login">|</span>
                    <a class="help-text-login" @click="openManage">Quản lý</a>
                    <span class="help-text-login">|</span>
                    <a href="#" class="help-text-login">Nhập trả</a>
                </div>
            </ul>

        </div>

        <div>
            <button type="button" class="btn btn-link text-light" @click="toggleFullScreen"><i class="fa fa-arrows-alt" id="btn-fullscreen-sale"></i></button>
            <button type="button" class="btn btn-link text-light"><i class="fa fa-question"></i></button>
        </div>

        <div class="navbar-select-branch">
            <select id="branch" name="branch" class="form-control form-control-sm">
                <option value="Chi nhánh trung tâm" selected="selected">Chi nhánh trung tâm</option>
            </select>
        </div>

        <ul class="navbar-nav">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle navbar-user" href="#" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" v-html="welcome_user"
                   @click="toggleUserMenu" @blur="closeUserMenu">
                    <br>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink" :class="{'show' : showUserMenu}">
                    <a href="#" class="dropdown-item">Tài khoản</a>
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item">Đăng xuất</a>
                </div>
            </li>
        </ul>

    </nav>
</template>

<script>
    import { mapGetters } from 'vuex';
    export default {
        data: () => ({
            showUserMenu: false
        }),

        computed: {
            ...mapGetters([
                'user'
            ]),
            welcome_user () {
                return "Xin chào<br>" + this.user.fullname
            }
        },
        methods: {
            openReport () {
                window.open('/manage/reports', '_blank')
            },
            openManage () {
                window.open('/manage', '_blank')
            },
            toggleFullScreen () {
                var isInFullScreen = (document.fullscreenElement && document.fullscreenElement !== null) ||
                    (document.webkitFullscreenElement && document.webkitFullscreenElement !== null) ||
                    (document.mozFullScreenElement && document.mozFullScreenElement !== null) ||
                    (document.msFullscreenElement && document.msFullscreenElement !== null);

                var docElm = document.documentElement;
                if (!isInFullScreen) {
                    if (docElm.requestFullscreen) {
                        docElm.requestFullscreen();
                    } else if (docElm.mozRequestFullScreen) {
                        docElm.mozRequestFullScreen();
                    } else if (docElm.webkitRequestFullScreen) {
                        docElm.webkitRequestFullScreen();
                    } else if (docElm.msRequestFullscreen) {
                        docElm.msRequestFullscreen();
                    }

                    document.getElementById("btn-fullscreen-sale").className = "fa fa-compress";
                } else {
                    if (document.exitFullscreen) {
                        document.exitFullscreen();
                    } else if (document.webkitExitFullscreen) {
                        document.webkitExitFullscreen();
                    } else if (document.mozCancelFullScreen) {
                        document.mozCancelFullScreen();
                    } else if (document.msExitFullscreen) {
                        document.msExitFullscreen();
                    }

                    document.getElementById("btn-fullscreen-sale").className = "fa fa-arrows-alt";
                }
            },
            toggleUserMenu () {
                this.showUserMenu = !this.showUserMenu
            },
            closeUserMenu () {
                this.showUserMenu = false
            },

        }
    }
</script>

<style scoped>

</style>