
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: YouTube Analytics
## version: v1beta1
## termsOfService: (not provided)
## license: (not provided)
## 
## Retrieves your YouTube Analytics data.
## 
## http://developers.google.com/youtube/analytics/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "youtubeAnalytics"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubeAnalyticsGroupItemsInsert_579962 = ref object of OpenApiRestCall_579424
proc url_YoutubeAnalyticsGroupItemsInsert_579964(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsInsert_579963(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a group item.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579965 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "onBehalfOfContentOwner", valid_579965
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("alt")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("json"))
  if valid_579968 != nil:
    section.add "alt", valid_579968
  var valid_579969 = query.getOrDefault("oauth_token")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "oauth_token", valid_579969
  var valid_579970 = query.getOrDefault("userIp")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "userIp", valid_579970
  var valid_579971 = query.getOrDefault("key")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "key", valid_579971
  var valid_579972 = query.getOrDefault("prettyPrint")
  valid_579972 = validateParameter(valid_579972, JBool, required = false,
                                 default = newJBool(true))
  if valid_579972 != nil:
    section.add "prettyPrint", valid_579972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579974: Call_YoutubeAnalyticsGroupItemsInsert_579962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a group item.
  ## 
  let valid = call_579974.validator(path, query, header, formData, body)
  let scheme = call_579974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579974.url(scheme.get, call_579974.host, call_579974.base,
                         call_579974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579974, url, valid)

proc call*(call_579975: Call_YoutubeAnalyticsGroupItemsInsert_579962;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupItemsInsert
  ## Creates a group item.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579976 = newJObject()
  var body_579977 = newJObject()
  add(query_579976, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579976, "fields", newJString(fields))
  add(query_579976, "quotaUser", newJString(quotaUser))
  add(query_579976, "alt", newJString(alt))
  add(query_579976, "oauth_token", newJString(oauthToken))
  add(query_579976, "userIp", newJString(userIp))
  add(query_579976, "key", newJString(key))
  if body != nil:
    body_579977 = body
  add(query_579976, "prettyPrint", newJBool(prettyPrint))
  result = call_579975.call(nil, query_579976, nil, nil, body_579977)

var youtubeAnalyticsGroupItemsInsert* = Call_YoutubeAnalyticsGroupItemsInsert_579962(
    name: "youtubeAnalyticsGroupItemsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsInsert_579963,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupItemsInsert_579964,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsList_579692 = ref object of OpenApiRestCall_579424
proc url_YoutubeAnalyticsGroupItemsList_579694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsList_579693(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   groupId: JString (required)
  ##          : The id parameter specifies the unique ID of the group for which you want to retrieve group items.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579806 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "onBehalfOfContentOwner", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("userIp")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "userIp", valid_579824
  assert query != nil, "query argument is necessary due to required `groupId` field"
  var valid_579825 = query.getOrDefault("groupId")
  valid_579825 = validateParameter(valid_579825, JString, required = true,
                                 default = nil)
  if valid_579825 != nil:
    section.add "groupId", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("prettyPrint")
  valid_579827 = validateParameter(valid_579827, JBool, required = false,
                                 default = newJBool(true))
  if valid_579827 != nil:
    section.add "prettyPrint", valid_579827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579850: Call_YoutubeAnalyticsGroupItemsList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  let valid = call_579850.validator(path, query, header, formData, body)
  let scheme = call_579850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579850.url(scheme.get, call_579850.host, call_579850.base,
                         call_579850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579850, url, valid)

proc call*(call_579921: Call_YoutubeAnalyticsGroupItemsList_579692;
          groupId: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupItemsList
  ## Returns a collection of group items that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   groupId: string (required)
  ##          : The id parameter specifies the unique ID of the group for which you want to retrieve group items.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579922 = newJObject()
  add(query_579922, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579922, "fields", newJString(fields))
  add(query_579922, "quotaUser", newJString(quotaUser))
  add(query_579922, "alt", newJString(alt))
  add(query_579922, "oauth_token", newJString(oauthToken))
  add(query_579922, "userIp", newJString(userIp))
  add(query_579922, "groupId", newJString(groupId))
  add(query_579922, "key", newJString(key))
  add(query_579922, "prettyPrint", newJBool(prettyPrint))
  result = call_579921.call(nil, query_579922, nil, nil, nil)

var youtubeAnalyticsGroupItemsList* = Call_YoutubeAnalyticsGroupItemsList_579692(
    name: "youtubeAnalyticsGroupItemsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsList_579693,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupItemsList_579694,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsDelete_579978 = ref object of OpenApiRestCall_579424
proc url_YoutubeAnalyticsGroupItemsDelete_579980(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsDelete_579979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an item from a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube group item ID for the group that is being deleted.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579981 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "onBehalfOfContentOwner", valid_579981
  var valid_579982 = query.getOrDefault("fields")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "fields", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_579984 = query.getOrDefault("id")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "id", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("userIp")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "userIp", valid_579987
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("prettyPrint")
  valid_579989 = validateParameter(valid_579989, JBool, required = false,
                                 default = newJBool(true))
  if valid_579989 != nil:
    section.add "prettyPrint", valid_579989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579990: Call_YoutubeAnalyticsGroupItemsDelete_579978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an item from a group.
  ## 
  let valid = call_579990.validator(path, query, header, formData, body)
  let scheme = call_579990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579990.url(scheme.get, call_579990.host, call_579990.base,
                         call_579990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579990, url, valid)

proc call*(call_579991: Call_YoutubeAnalyticsGroupItemsDelete_579978; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupItemsDelete
  ## Removes an item from a group.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube group item ID for the group that is being deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579992 = newJObject()
  add(query_579992, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(query_579992, "id", newJString(id))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "userIp", newJString(userIp))
  add(query_579992, "key", newJString(key))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  result = call_579991.call(nil, query_579992, nil, nil, nil)

var youtubeAnalyticsGroupItemsDelete* = Call_YoutubeAnalyticsGroupItemsDelete_579978(
    name: "youtubeAnalyticsGroupItemsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsDelete_579979,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupItemsDelete_579980,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsUpdate_580010 = ref object of OpenApiRestCall_579424
proc url_YoutubeAnalyticsGroupsUpdate_580012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsUpdate_580011(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580013 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "onBehalfOfContentOwner", valid_580013
  var valid_580014 = query.getOrDefault("fields")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "fields", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("userIp")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "userIp", valid_580018
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("prettyPrint")
  valid_580020 = validateParameter(valid_580020, JBool, required = false,
                                 default = newJBool(true))
  if valid_580020 != nil:
    section.add "prettyPrint", valid_580020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_YoutubeAnalyticsGroupsUpdate_580010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_YoutubeAnalyticsGroupsUpdate_580010;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsUpdate
  ## Modifies a group. For example, you could change a group's title.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580024 = newJObject()
  var body_580025 = newJObject()
  add(query_580024, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580024, "fields", newJString(fields))
  add(query_580024, "quotaUser", newJString(quotaUser))
  add(query_580024, "alt", newJString(alt))
  add(query_580024, "oauth_token", newJString(oauthToken))
  add(query_580024, "userIp", newJString(userIp))
  add(query_580024, "key", newJString(key))
  if body != nil:
    body_580025 = body
  add(query_580024, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(nil, query_580024, nil, nil, body_580025)

var youtubeAnalyticsGroupsUpdate* = Call_YoutubeAnalyticsGroupsUpdate_580010(
    name: "youtubeAnalyticsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_YoutubeAnalyticsGroupsUpdate_580011,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupsUpdate_580012,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsInsert_580026 = ref object of OpenApiRestCall_579424
proc url_YoutubeAnalyticsGroupsInsert_580028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsInsert_580027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580029 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "onBehalfOfContentOwner", valid_580029
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("alt")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("json"))
  if valid_580032 != nil:
    section.add "alt", valid_580032
  var valid_580033 = query.getOrDefault("oauth_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "oauth_token", valid_580033
  var valid_580034 = query.getOrDefault("userIp")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "userIp", valid_580034
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580038: Call_YoutubeAnalyticsGroupsInsert_580026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a group.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_YoutubeAnalyticsGroupsInsert_580026;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsInsert
  ## Creates a group.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580040 = newJObject()
  var body_580041 = newJObject()
  add(query_580040, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580040, "fields", newJString(fields))
  add(query_580040, "quotaUser", newJString(quotaUser))
  add(query_580040, "alt", newJString(alt))
  add(query_580040, "oauth_token", newJString(oauthToken))
  add(query_580040, "userIp", newJString(userIp))
  add(query_580040, "key", newJString(key))
  if body != nil:
    body_580041 = body
  add(query_580040, "prettyPrint", newJBool(prettyPrint))
  result = call_580039.call(nil, query_580040, nil, nil, body_580041)

var youtubeAnalyticsGroupsInsert* = Call_YoutubeAnalyticsGroupsInsert_580026(
    name: "youtubeAnalyticsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_YoutubeAnalyticsGroupsInsert_580027,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupsInsert_580028,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsList_579993 = ref object of OpenApiRestCall_579424
proc url_YoutubeAnalyticsGroupsList_579995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsList_579994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of groups that match the API request parameters. For example, you can retrieve all groups that the authenticated user owns, or you can retrieve one or more groups by their unique IDs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to instruct the API to only return groups owned by the authenticated user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page that can be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube group ID(s) for the resource(s) that are being retrieved. In a group resource, the id property specifies the group's YouTube group ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579996 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "onBehalfOfContentOwner", valid_579996
  var valid_579997 = query.getOrDefault("mine")
  valid_579997 = validateParameter(valid_579997, JBool, required = false, default = nil)
  if valid_579997 != nil:
    section.add "mine", valid_579997
  var valid_579998 = query.getOrDefault("fields")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "fields", valid_579998
  var valid_579999 = query.getOrDefault("pageToken")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "pageToken", valid_579999
  var valid_580000 = query.getOrDefault("quotaUser")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "quotaUser", valid_580000
  var valid_580001 = query.getOrDefault("id")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "id", valid_580001
  var valid_580002 = query.getOrDefault("alt")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = newJString("json"))
  if valid_580002 != nil:
    section.add "alt", valid_580002
  var valid_580003 = query.getOrDefault("oauth_token")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "oauth_token", valid_580003
  var valid_580004 = query.getOrDefault("userIp")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "userIp", valid_580004
  var valid_580005 = query.getOrDefault("key")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "key", valid_580005
  var valid_580006 = query.getOrDefault("prettyPrint")
  valid_580006 = validateParameter(valid_580006, JBool, required = false,
                                 default = newJBool(true))
  if valid_580006 != nil:
    section.add "prettyPrint", valid_580006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580007: Call_YoutubeAnalyticsGroupsList_579993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of groups that match the API request parameters. For example, you can retrieve all groups that the authenticated user owns, or you can retrieve one or more groups by their unique IDs.
  ## 
  let valid = call_580007.validator(path, query, header, formData, body)
  let scheme = call_580007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580007.url(scheme.get, call_580007.host, call_580007.base,
                         call_580007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580007, url, valid)

proc call*(call_580008: Call_YoutubeAnalyticsGroupsList_579993;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsList
  ## Returns a collection of groups that match the API request parameters. For example, you can retrieve all groups that the authenticated user owns, or you can retrieve one or more groups by their unique IDs.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to instruct the API to only return groups owned by the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page that can be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube group ID(s) for the resource(s) that are being retrieved. In a group resource, the id property specifies the group's YouTube group ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580009 = newJObject()
  add(query_580009, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580009, "mine", newJBool(mine))
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "pageToken", newJString(pageToken))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "id", newJString(id))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "key", newJString(key))
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580008.call(nil, query_580009, nil, nil, nil)

var youtubeAnalyticsGroupsList* = Call_YoutubeAnalyticsGroupsList_579993(
    name: "youtubeAnalyticsGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_YoutubeAnalyticsGroupsList_579994,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupsList_579995,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsDelete_580042 = ref object of OpenApiRestCall_579424
proc url_YoutubeAnalyticsGroupsDelete_580044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsDelete_580043(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube group ID for the group that is being deleted.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580045 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "onBehalfOfContentOwner", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580048 = query.getOrDefault("id")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "id", valid_580048
  var valid_580049 = query.getOrDefault("alt")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = newJString("json"))
  if valid_580049 != nil:
    section.add "alt", valid_580049
  var valid_580050 = query.getOrDefault("oauth_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "oauth_token", valid_580050
  var valid_580051 = query.getOrDefault("userIp")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "userIp", valid_580051
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580054: Call_YoutubeAnalyticsGroupsDelete_580042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a group.
  ## 
  let valid = call_580054.validator(path, query, header, formData, body)
  let scheme = call_580054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580054.url(scheme.get, call_580054.host, call_580054.base,
                         call_580054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580054, url, valid)

proc call*(call_580055: Call_YoutubeAnalyticsGroupsDelete_580042; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsDelete
  ## Deletes a group.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube group ID for the group that is being deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580056 = newJObject()
  add(query_580056, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580056, "fields", newJString(fields))
  add(query_580056, "quotaUser", newJString(quotaUser))
  add(query_580056, "id", newJString(id))
  add(query_580056, "alt", newJString(alt))
  add(query_580056, "oauth_token", newJString(oauthToken))
  add(query_580056, "userIp", newJString(userIp))
  add(query_580056, "key", newJString(key))
  add(query_580056, "prettyPrint", newJBool(prettyPrint))
  result = call_580055.call(nil, query_580056, nil, nil, nil)

var youtubeAnalyticsGroupsDelete* = Call_YoutubeAnalyticsGroupsDelete_580042(
    name: "youtubeAnalyticsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_YoutubeAnalyticsGroupsDelete_580043,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupsDelete_580044,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsReportsQuery_580057 = ref object of OpenApiRestCall_579424
proc url_YoutubeAnalyticsReportsQuery_580059(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsReportsQuery_580058(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve your YouTube Analytics reports.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   include-historical-channel-data: JBool
  ##                                  : If set to true historical data (i.e. channel data from before the linking of the channel to the content owner) will be retrieved.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   currency: JString
  ##           : The currency to which financial metrics should be converted. The default is US Dollar (USD). If the result contains no financial metrics, this flag will be ignored. Responds with an error if the specified currency is not recognized.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for YouTube Analytics data. By default the sort order is ascending. The '-' prefix causes descending sort order.
  ##   metrics: JString (required)
  ##          : A comma-separated list of YouTube Analytics metrics, such as views or likes,dislikes. See the Available Reports document for a list of the reports that you can retrieve and the metrics available in each report, and see the Metrics document for definitions of those metrics.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: JString
  ##             : A comma-separated list of YouTube Analytics dimensions, such as views or ageGroup,gender. See the Available Reports document for a list of the reports that you can retrieve and the dimensions used for those reports. Also see the Dimensions document for definitions of those dimensions.
  ##   ids: JString (required)
  ##      : Identifies the YouTube channel or content owner for which you are retrieving YouTube Analytics data.
  ## - To request data for a YouTube user, set the ids parameter value to channel==CHANNEL_ID, where CHANNEL_ID specifies the unique YouTube channel ID.
  ## - To request data for a YouTube CMS content owner, set the ids parameter value to contentOwner==OWNER_NAME, where OWNER_NAME is the CMS name of the content owner.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of rows to include in the response.
  ##   end-date: JString (required)
  ##           : The end date for fetching YouTube Analytics data. The value should be in YYYY-MM-DD format.
  ##   start-date: JString (required)
  ##             : The start date for fetching YouTube Analytics data. The value should be in YYYY-MM-DD format.
  ##   filters: JString
  ##          : A list of filters that should be applied when retrieving YouTube Analytics data. The Available Reports document identifies the dimensions that can be used to filter each report, and the Dimensions document defines those dimensions. If a request uses multiple filters, join them together with a semicolon (;), and the returned result table will satisfy both filters. For example, a filters parameter value of video==dMH0bHeiRNg;country==IT restricts the result set to include data for the given video in Italy.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter (one-based, inclusive).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580060 = query.getOrDefault("include-historical-channel-data")
  valid_580060 = validateParameter(valid_580060, JBool, required = false, default = nil)
  if valid_580060 != nil:
    section.add "include-historical-channel-data", valid_580060
  var valid_580061 = query.getOrDefault("fields")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "fields", valid_580061
  var valid_580062 = query.getOrDefault("quotaUser")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "quotaUser", valid_580062
  var valid_580063 = query.getOrDefault("alt")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("json"))
  if valid_580063 != nil:
    section.add "alt", valid_580063
  var valid_580064 = query.getOrDefault("currency")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "currency", valid_580064
  var valid_580065 = query.getOrDefault("sort")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "sort", valid_580065
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_580066 = query.getOrDefault("metrics")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "metrics", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("userIp")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "userIp", valid_580068
  var valid_580069 = query.getOrDefault("dimensions")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "dimensions", valid_580069
  var valid_580070 = query.getOrDefault("ids")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "ids", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("max-results")
  valid_580072 = validateParameter(valid_580072, JInt, required = false, default = nil)
  if valid_580072 != nil:
    section.add "max-results", valid_580072
  var valid_580073 = query.getOrDefault("end-date")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "end-date", valid_580073
  var valid_580074 = query.getOrDefault("start-date")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "start-date", valid_580074
  var valid_580075 = query.getOrDefault("filters")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "filters", valid_580075
  var valid_580076 = query.getOrDefault("start-index")
  valid_580076 = validateParameter(valid_580076, JInt, required = false, default = nil)
  if valid_580076 != nil:
    section.add "start-index", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580078: Call_YoutubeAnalyticsReportsQuery_580057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve your YouTube Analytics reports.
  ## 
  let valid = call_580078.validator(path, query, header, formData, body)
  let scheme = call_580078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580078.url(scheme.get, call_580078.host, call_580078.base,
                         call_580078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580078, url, valid)

proc call*(call_580079: Call_YoutubeAnalyticsReportsQuery_580057; metrics: string;
          ids: string; endDate: string; startDate: string;
          includeHistoricalChannelData: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; currency: string = "";
          sort: string = ""; oauthToken: string = ""; userIp: string = "";
          dimensions: string = ""; key: string = ""; maxResults: int = 0;
          filters: string = ""; startIndex: int = 0; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsReportsQuery
  ## Retrieve your YouTube Analytics reports.
  ##   includeHistoricalChannelData: bool
  ##                               : If set to true historical data (i.e. channel data from before the linking of the channel to the content owner) will be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   currency: string
  ##           : The currency to which financial metrics should be converted. The default is US Dollar (USD). If the result contains no financial metrics, this flag will be ignored. Responds with an error if the specified currency is not recognized.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for YouTube Analytics data. By default the sort order is ascending. The '-' prefix causes descending sort order.
  ##   metrics: string (required)
  ##          : A comma-separated list of YouTube Analytics metrics, such as views or likes,dislikes. See the Available Reports document for a list of the reports that you can retrieve and the metrics available in each report, and see the Metrics document for definitions of those metrics.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: string
  ##             : A comma-separated list of YouTube Analytics dimensions, such as views or ageGroup,gender. See the Available Reports document for a list of the reports that you can retrieve and the dimensions used for those reports. Also see the Dimensions document for definitions of those dimensions.
  ##   ids: string (required)
  ##      : Identifies the YouTube channel or content owner for which you are retrieving YouTube Analytics data.
  ## - To request data for a YouTube user, set the ids parameter value to channel==CHANNEL_ID, where CHANNEL_ID specifies the unique YouTube channel ID.
  ## - To request data for a YouTube CMS content owner, set the ids parameter value to contentOwner==OWNER_NAME, where OWNER_NAME is the CMS name of the content owner.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of rows to include in the response.
  ##   endDate: string (required)
  ##          : The end date for fetching YouTube Analytics data. The value should be in YYYY-MM-DD format.
  ##   startDate: string (required)
  ##            : The start date for fetching YouTube Analytics data. The value should be in YYYY-MM-DD format.
  ##   filters: string
  ##          : A list of filters that should be applied when retrieving YouTube Analytics data. The Available Reports document identifies the dimensions that can be used to filter each report, and the Dimensions document defines those dimensions. If a request uses multiple filters, join them together with a semicolon (;), and the returned result table will satisfy both filters. For example, a filters parameter value of video==dMH0bHeiRNg;country==IT restricts the result set to include data for the given video in Italy.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter (one-based, inclusive).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580080 = newJObject()
  add(query_580080, "include-historical-channel-data",
      newJBool(includeHistoricalChannelData))
  add(query_580080, "fields", newJString(fields))
  add(query_580080, "quotaUser", newJString(quotaUser))
  add(query_580080, "alt", newJString(alt))
  add(query_580080, "currency", newJString(currency))
  add(query_580080, "sort", newJString(sort))
  add(query_580080, "metrics", newJString(metrics))
  add(query_580080, "oauth_token", newJString(oauthToken))
  add(query_580080, "userIp", newJString(userIp))
  add(query_580080, "dimensions", newJString(dimensions))
  add(query_580080, "ids", newJString(ids))
  add(query_580080, "key", newJString(key))
  add(query_580080, "max-results", newJInt(maxResults))
  add(query_580080, "end-date", newJString(endDate))
  add(query_580080, "start-date", newJString(startDate))
  add(query_580080, "filters", newJString(filters))
  add(query_580080, "start-index", newJInt(startIndex))
  add(query_580080, "prettyPrint", newJBool(prettyPrint))
  result = call_580079.call(nil, query_580080, nil, nil, nil)

var youtubeAnalyticsReportsQuery* = Call_YoutubeAnalyticsReportsQuery_580057(
    name: "youtubeAnalyticsReportsQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_YoutubeAnalyticsReportsQuery_580058,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsReportsQuery_580059,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
