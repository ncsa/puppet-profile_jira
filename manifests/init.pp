# @summary Configure a server for running Jira
#
# Configure a server for running Jira
#
# @example
#   include profile_jira
class profile_jira (
  String  $jira_home,
  String  $backup_dir,
  Integer $backups_max_qty,
) {

  ### Jira Backups
  $jira_backup = '/root/cron_scripts/jira-backup.sh'
  file { $jira_backup :
    ensure  => file,
    mode    => '0700',
    owner   => 'root',
    group   => '0',
    content => epp("profile_jira/${jira_backup}.epp", {
        jira_home  => $jira_home,
        backup_dir => "${backup_dir}/jirahome",
        rotate     => $backups_max_qty,
      }
    ),
  }

  cron { 'jira home backup':
    command => $jira_backup,
    hour   => 4,
    minute => 4,
    user   => 'root',
  }
}
