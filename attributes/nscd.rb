default['pam']['nscd'].tap do |nscd|
  nscd['daemon'].tap do |daemon|
    daemon['debug-level'] = 0
    daemon['paranoia'] = 'no'
  end

  nscd['cache_names'].tap do |cache_names|
    cache_names['passwd'].tap do |passwd|
      passwd['enable-cache'] = 'yes'
      passwd['positive-time-to-live'] = '600'
      passwd['negative-time-to-live'] = '20'
      passwd['suggested-size'] = '211'
      passwd['check-files'] = 'yes'
      passwd['persistent'] = 'no'
      passwd['shared'] = 'yes'
      passwd['max-db-size'] = '33554432'
      passwd['auto-propagate'] = 'yes'
    end

    cache_names['group'].tap do |group|
      group['enable-cache'] = 'yes'
      group['positive-time-to-live'] = '300'
      group['negative-time-to-live'] = '60'
      group['suggested-size'] = '211'
      group['check-files'] = 'yes'
      group['persistent'] = 'no'
      group['shared'] = 'yes'
      group['max-db-size'] = '33554432'
      group['auto-propagate'] = 'yes'
    end

    cache_names['hosts'].tap do |hosts|
      hosts['enable-cache'] = 'yes'
      hosts['positive-time-to-live'] = '3600'
      hosts['negative-time-to-live'] = '20'
      hosts['suggested-size'] = '211'
      hosts['check-files'] = 'yes'
      hosts['persistent'] = 'yes'
      hosts['shared'] = 'yes'
      hosts['max-db-size'] = '33554432'
    end

    cache_names['services'].tap do |services|
      services['enable-cache'] = 'yes'
      services['positive-time-to-live'] = '28800'
      services['negative-time-to-live'] = '20'
      services['suggested-size'] = '211'
      services['check-files'] = 'yes'
      services['persistent'] = 'yes'
      services['shared'] = 'yes'
      services['max-db-size'] = '33554432'
    end

    cache_names['netgroup'].tap do |netgroup|
      netgroup['enable-cache'] = 'no'
      netgroup['positive-time-to-live'] = '28800'
      netgroup['negative-time-to-live'] = '20'
      netgroup['suggested-size'] = '211'
      netgroup['check-files'] = 'yes'
      netgroup['persistent'] = 'yes'
      netgroup['shared'] = 'yes'
      netgroup['max-db-size'] = '33554432'
    end
  end
end
