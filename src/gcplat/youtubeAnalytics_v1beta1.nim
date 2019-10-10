
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_YoutubeAnalyticsGroupItemsInsert_588995 = ref object of OpenApiRestCall_588457
proc url_YoutubeAnalyticsGroupItemsInsert_588997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsInsert_588996(path: JsonNode;
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
  var valid_588998 = query.getOrDefault("onBehalfOfContentOwner")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "onBehalfOfContentOwner", valid_588998
  var valid_588999 = query.getOrDefault("fields")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "fields", valid_588999
  var valid_589000 = query.getOrDefault("quotaUser")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "quotaUser", valid_589000
  var valid_589001 = query.getOrDefault("alt")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = newJString("json"))
  if valid_589001 != nil:
    section.add "alt", valid_589001
  var valid_589002 = query.getOrDefault("oauth_token")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "oauth_token", valid_589002
  var valid_589003 = query.getOrDefault("userIp")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "userIp", valid_589003
  var valid_589004 = query.getOrDefault("key")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "key", valid_589004
  var valid_589005 = query.getOrDefault("prettyPrint")
  valid_589005 = validateParameter(valid_589005, JBool, required = false,
                                 default = newJBool(true))
  if valid_589005 != nil:
    section.add "prettyPrint", valid_589005
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

proc call*(call_589007: Call_YoutubeAnalyticsGroupItemsInsert_588995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a group item.
  ## 
  let valid = call_589007.validator(path, query, header, formData, body)
  let scheme = call_589007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589007.url(scheme.get, call_589007.host, call_589007.base,
                         call_589007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589007, url, valid)

proc call*(call_589008: Call_YoutubeAnalyticsGroupItemsInsert_588995;
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
  var query_589009 = newJObject()
  var body_589010 = newJObject()
  add(query_589009, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589009, "fields", newJString(fields))
  add(query_589009, "quotaUser", newJString(quotaUser))
  add(query_589009, "alt", newJString(alt))
  add(query_589009, "oauth_token", newJString(oauthToken))
  add(query_589009, "userIp", newJString(userIp))
  add(query_589009, "key", newJString(key))
  if body != nil:
    body_589010 = body
  add(query_589009, "prettyPrint", newJBool(prettyPrint))
  result = call_589008.call(nil, query_589009, nil, nil, body_589010)

var youtubeAnalyticsGroupItemsInsert* = Call_YoutubeAnalyticsGroupItemsInsert_588995(
    name: "youtubeAnalyticsGroupItemsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsInsert_588996,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupItemsInsert_588997,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsList_588725 = ref object of OpenApiRestCall_588457
proc url_YoutubeAnalyticsGroupItemsList_588727(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsList_588726(path: JsonNode;
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
  var valid_588839 = query.getOrDefault("onBehalfOfContentOwner")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "onBehalfOfContentOwner", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("userIp")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "userIp", valid_588857
  assert query != nil, "query argument is necessary due to required `groupId` field"
  var valid_588858 = query.getOrDefault("groupId")
  valid_588858 = validateParameter(valid_588858, JString, required = true,
                                 default = nil)
  if valid_588858 != nil:
    section.add "groupId", valid_588858
  var valid_588859 = query.getOrDefault("key")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "key", valid_588859
  var valid_588860 = query.getOrDefault("prettyPrint")
  valid_588860 = validateParameter(valid_588860, JBool, required = false,
                                 default = newJBool(true))
  if valid_588860 != nil:
    section.add "prettyPrint", valid_588860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588883: Call_YoutubeAnalyticsGroupItemsList_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_YoutubeAnalyticsGroupItemsList_588725;
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
  var query_588955 = newJObject()
  add(query_588955, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_588955, "fields", newJString(fields))
  add(query_588955, "quotaUser", newJString(quotaUser))
  add(query_588955, "alt", newJString(alt))
  add(query_588955, "oauth_token", newJString(oauthToken))
  add(query_588955, "userIp", newJString(userIp))
  add(query_588955, "groupId", newJString(groupId))
  add(query_588955, "key", newJString(key))
  add(query_588955, "prettyPrint", newJBool(prettyPrint))
  result = call_588954.call(nil, query_588955, nil, nil, nil)

var youtubeAnalyticsGroupItemsList* = Call_YoutubeAnalyticsGroupItemsList_588725(
    name: "youtubeAnalyticsGroupItemsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsList_588726,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupItemsList_588727,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsDelete_589011 = ref object of OpenApiRestCall_588457
proc url_YoutubeAnalyticsGroupItemsDelete_589013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsDelete_589012(path: JsonNode;
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
  var valid_589014 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "onBehalfOfContentOwner", valid_589014
  var valid_589015 = query.getOrDefault("fields")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "fields", valid_589015
  var valid_589016 = query.getOrDefault("quotaUser")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "quotaUser", valid_589016
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589017 = query.getOrDefault("id")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = nil)
  if valid_589017 != nil:
    section.add "id", valid_589017
  var valid_589018 = query.getOrDefault("alt")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("json"))
  if valid_589018 != nil:
    section.add "alt", valid_589018
  var valid_589019 = query.getOrDefault("oauth_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "oauth_token", valid_589019
  var valid_589020 = query.getOrDefault("userIp")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "userIp", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("prettyPrint")
  valid_589022 = validateParameter(valid_589022, JBool, required = false,
                                 default = newJBool(true))
  if valid_589022 != nil:
    section.add "prettyPrint", valid_589022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589023: Call_YoutubeAnalyticsGroupItemsDelete_589011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an item from a group.
  ## 
  let valid = call_589023.validator(path, query, header, formData, body)
  let scheme = call_589023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589023.url(scheme.get, call_589023.host, call_589023.base,
                         call_589023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589023, url, valid)

proc call*(call_589024: Call_YoutubeAnalyticsGroupItemsDelete_589011; id: string;
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
  var query_589025 = newJObject()
  add(query_589025, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(query_589025, "id", newJString(id))
  add(query_589025, "alt", newJString(alt))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(query_589025, "userIp", newJString(userIp))
  add(query_589025, "key", newJString(key))
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  result = call_589024.call(nil, query_589025, nil, nil, nil)

var youtubeAnalyticsGroupItemsDelete* = Call_YoutubeAnalyticsGroupItemsDelete_589011(
    name: "youtubeAnalyticsGroupItemsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsDelete_589012,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupItemsDelete_589013,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsUpdate_589043 = ref object of OpenApiRestCall_588457
proc url_YoutubeAnalyticsGroupsUpdate_589045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsUpdate_589044(path: JsonNode; query: JsonNode;
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
  var valid_589046 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "onBehalfOfContentOwner", valid_589046
  var valid_589047 = query.getOrDefault("fields")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "fields", valid_589047
  var valid_589048 = query.getOrDefault("quotaUser")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "quotaUser", valid_589048
  var valid_589049 = query.getOrDefault("alt")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("json"))
  if valid_589049 != nil:
    section.add "alt", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("userIp")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "userIp", valid_589051
  var valid_589052 = query.getOrDefault("key")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "key", valid_589052
  var valid_589053 = query.getOrDefault("prettyPrint")
  valid_589053 = validateParameter(valid_589053, JBool, required = false,
                                 default = newJBool(true))
  if valid_589053 != nil:
    section.add "prettyPrint", valid_589053
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

proc call*(call_589055: Call_YoutubeAnalyticsGroupsUpdate_589043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  let valid = call_589055.validator(path, query, header, formData, body)
  let scheme = call_589055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589055.url(scheme.get, call_589055.host, call_589055.base,
                         call_589055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589055, url, valid)

proc call*(call_589056: Call_YoutubeAnalyticsGroupsUpdate_589043;
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
  var query_589057 = newJObject()
  var body_589058 = newJObject()
  add(query_589057, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589057, "fields", newJString(fields))
  add(query_589057, "quotaUser", newJString(quotaUser))
  add(query_589057, "alt", newJString(alt))
  add(query_589057, "oauth_token", newJString(oauthToken))
  add(query_589057, "userIp", newJString(userIp))
  add(query_589057, "key", newJString(key))
  if body != nil:
    body_589058 = body
  add(query_589057, "prettyPrint", newJBool(prettyPrint))
  result = call_589056.call(nil, query_589057, nil, nil, body_589058)

var youtubeAnalyticsGroupsUpdate* = Call_YoutubeAnalyticsGroupsUpdate_589043(
    name: "youtubeAnalyticsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_YoutubeAnalyticsGroupsUpdate_589044,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupsUpdate_589045,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsInsert_589059 = ref object of OpenApiRestCall_588457
proc url_YoutubeAnalyticsGroupsInsert_589061(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsInsert_589060(path: JsonNode; query: JsonNode;
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
  var valid_589062 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "onBehalfOfContentOwner", valid_589062
  var valid_589063 = query.getOrDefault("fields")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "fields", valid_589063
  var valid_589064 = query.getOrDefault("quotaUser")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "quotaUser", valid_589064
  var valid_589065 = query.getOrDefault("alt")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("json"))
  if valid_589065 != nil:
    section.add "alt", valid_589065
  var valid_589066 = query.getOrDefault("oauth_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "oauth_token", valid_589066
  var valid_589067 = query.getOrDefault("userIp")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "userIp", valid_589067
  var valid_589068 = query.getOrDefault("key")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "key", valid_589068
  var valid_589069 = query.getOrDefault("prettyPrint")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "prettyPrint", valid_589069
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

proc call*(call_589071: Call_YoutubeAnalyticsGroupsInsert_589059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a group.
  ## 
  let valid = call_589071.validator(path, query, header, formData, body)
  let scheme = call_589071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589071.url(scheme.get, call_589071.host, call_589071.base,
                         call_589071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589071, url, valid)

proc call*(call_589072: Call_YoutubeAnalyticsGroupsInsert_589059;
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
  var query_589073 = newJObject()
  var body_589074 = newJObject()
  add(query_589073, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589073, "fields", newJString(fields))
  add(query_589073, "quotaUser", newJString(quotaUser))
  add(query_589073, "alt", newJString(alt))
  add(query_589073, "oauth_token", newJString(oauthToken))
  add(query_589073, "userIp", newJString(userIp))
  add(query_589073, "key", newJString(key))
  if body != nil:
    body_589074 = body
  add(query_589073, "prettyPrint", newJBool(prettyPrint))
  result = call_589072.call(nil, query_589073, nil, nil, body_589074)

var youtubeAnalyticsGroupsInsert* = Call_YoutubeAnalyticsGroupsInsert_589059(
    name: "youtubeAnalyticsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_YoutubeAnalyticsGroupsInsert_589060,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupsInsert_589061,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsList_589026 = ref object of OpenApiRestCall_588457
proc url_YoutubeAnalyticsGroupsList_589028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsList_589027(path: JsonNode; query: JsonNode;
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
  var valid_589029 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "onBehalfOfContentOwner", valid_589029
  var valid_589030 = query.getOrDefault("mine")
  valid_589030 = validateParameter(valid_589030, JBool, required = false, default = nil)
  if valid_589030 != nil:
    section.add "mine", valid_589030
  var valid_589031 = query.getOrDefault("fields")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "fields", valid_589031
  var valid_589032 = query.getOrDefault("pageToken")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "pageToken", valid_589032
  var valid_589033 = query.getOrDefault("quotaUser")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "quotaUser", valid_589033
  var valid_589034 = query.getOrDefault("id")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "id", valid_589034
  var valid_589035 = query.getOrDefault("alt")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = newJString("json"))
  if valid_589035 != nil:
    section.add "alt", valid_589035
  var valid_589036 = query.getOrDefault("oauth_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "oauth_token", valid_589036
  var valid_589037 = query.getOrDefault("userIp")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "userIp", valid_589037
  var valid_589038 = query.getOrDefault("key")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "key", valid_589038
  var valid_589039 = query.getOrDefault("prettyPrint")
  valid_589039 = validateParameter(valid_589039, JBool, required = false,
                                 default = newJBool(true))
  if valid_589039 != nil:
    section.add "prettyPrint", valid_589039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589040: Call_YoutubeAnalyticsGroupsList_589026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of groups that match the API request parameters. For example, you can retrieve all groups that the authenticated user owns, or you can retrieve one or more groups by their unique IDs.
  ## 
  let valid = call_589040.validator(path, query, header, formData, body)
  let scheme = call_589040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589040.url(scheme.get, call_589040.host, call_589040.base,
                         call_589040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589040, url, valid)

proc call*(call_589041: Call_YoutubeAnalyticsGroupsList_589026;
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
  var query_589042 = newJObject()
  add(query_589042, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589042, "mine", newJBool(mine))
  add(query_589042, "fields", newJString(fields))
  add(query_589042, "pageToken", newJString(pageToken))
  add(query_589042, "quotaUser", newJString(quotaUser))
  add(query_589042, "id", newJString(id))
  add(query_589042, "alt", newJString(alt))
  add(query_589042, "oauth_token", newJString(oauthToken))
  add(query_589042, "userIp", newJString(userIp))
  add(query_589042, "key", newJString(key))
  add(query_589042, "prettyPrint", newJBool(prettyPrint))
  result = call_589041.call(nil, query_589042, nil, nil, nil)

var youtubeAnalyticsGroupsList* = Call_YoutubeAnalyticsGroupsList_589026(
    name: "youtubeAnalyticsGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_YoutubeAnalyticsGroupsList_589027,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupsList_589028,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsDelete_589075 = ref object of OpenApiRestCall_588457
proc url_YoutubeAnalyticsGroupsDelete_589077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsDelete_589076(path: JsonNode; query: JsonNode;
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
  var valid_589078 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "onBehalfOfContentOwner", valid_589078
  var valid_589079 = query.getOrDefault("fields")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "fields", valid_589079
  var valid_589080 = query.getOrDefault("quotaUser")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "quotaUser", valid_589080
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589081 = query.getOrDefault("id")
  valid_589081 = validateParameter(valid_589081, JString, required = true,
                                 default = nil)
  if valid_589081 != nil:
    section.add "id", valid_589081
  var valid_589082 = query.getOrDefault("alt")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("json"))
  if valid_589082 != nil:
    section.add "alt", valid_589082
  var valid_589083 = query.getOrDefault("oauth_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "oauth_token", valid_589083
  var valid_589084 = query.getOrDefault("userIp")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "userIp", valid_589084
  var valid_589085 = query.getOrDefault("key")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "key", valid_589085
  var valid_589086 = query.getOrDefault("prettyPrint")
  valid_589086 = validateParameter(valid_589086, JBool, required = false,
                                 default = newJBool(true))
  if valid_589086 != nil:
    section.add "prettyPrint", valid_589086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589087: Call_YoutubeAnalyticsGroupsDelete_589075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a group.
  ## 
  let valid = call_589087.validator(path, query, header, formData, body)
  let scheme = call_589087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589087.url(scheme.get, call_589087.host, call_589087.base,
                         call_589087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589087, url, valid)

proc call*(call_589088: Call_YoutubeAnalyticsGroupsDelete_589075; id: string;
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
  var query_589089 = newJObject()
  add(query_589089, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589089, "fields", newJString(fields))
  add(query_589089, "quotaUser", newJString(quotaUser))
  add(query_589089, "id", newJString(id))
  add(query_589089, "alt", newJString(alt))
  add(query_589089, "oauth_token", newJString(oauthToken))
  add(query_589089, "userIp", newJString(userIp))
  add(query_589089, "key", newJString(key))
  add(query_589089, "prettyPrint", newJBool(prettyPrint))
  result = call_589088.call(nil, query_589089, nil, nil, nil)

var youtubeAnalyticsGroupsDelete* = Call_YoutubeAnalyticsGroupsDelete_589075(
    name: "youtubeAnalyticsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_YoutubeAnalyticsGroupsDelete_589076,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsGroupsDelete_589077,
    schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsReportsQuery_589090 = ref object of OpenApiRestCall_588457
proc url_YoutubeAnalyticsReportsQuery_589092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsReportsQuery_589091(path: JsonNode; query: JsonNode;
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
  var valid_589093 = query.getOrDefault("include-historical-channel-data")
  valid_589093 = validateParameter(valid_589093, JBool, required = false, default = nil)
  if valid_589093 != nil:
    section.add "include-historical-channel-data", valid_589093
  var valid_589094 = query.getOrDefault("fields")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "fields", valid_589094
  var valid_589095 = query.getOrDefault("quotaUser")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "quotaUser", valid_589095
  var valid_589096 = query.getOrDefault("alt")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("json"))
  if valid_589096 != nil:
    section.add "alt", valid_589096
  var valid_589097 = query.getOrDefault("currency")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "currency", valid_589097
  var valid_589098 = query.getOrDefault("sort")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "sort", valid_589098
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_589099 = query.getOrDefault("metrics")
  valid_589099 = validateParameter(valid_589099, JString, required = true,
                                 default = nil)
  if valid_589099 != nil:
    section.add "metrics", valid_589099
  var valid_589100 = query.getOrDefault("oauth_token")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "oauth_token", valid_589100
  var valid_589101 = query.getOrDefault("userIp")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "userIp", valid_589101
  var valid_589102 = query.getOrDefault("dimensions")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "dimensions", valid_589102
  var valid_589103 = query.getOrDefault("ids")
  valid_589103 = validateParameter(valid_589103, JString, required = true,
                                 default = nil)
  if valid_589103 != nil:
    section.add "ids", valid_589103
  var valid_589104 = query.getOrDefault("key")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "key", valid_589104
  var valid_589105 = query.getOrDefault("max-results")
  valid_589105 = validateParameter(valid_589105, JInt, required = false, default = nil)
  if valid_589105 != nil:
    section.add "max-results", valid_589105
  var valid_589106 = query.getOrDefault("end-date")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "end-date", valid_589106
  var valid_589107 = query.getOrDefault("start-date")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "start-date", valid_589107
  var valid_589108 = query.getOrDefault("filters")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "filters", valid_589108
  var valid_589109 = query.getOrDefault("start-index")
  valid_589109 = validateParameter(valid_589109, JInt, required = false, default = nil)
  if valid_589109 != nil:
    section.add "start-index", valid_589109
  var valid_589110 = query.getOrDefault("prettyPrint")
  valid_589110 = validateParameter(valid_589110, JBool, required = false,
                                 default = newJBool(true))
  if valid_589110 != nil:
    section.add "prettyPrint", valid_589110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589111: Call_YoutubeAnalyticsReportsQuery_589090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve your YouTube Analytics reports.
  ## 
  let valid = call_589111.validator(path, query, header, formData, body)
  let scheme = call_589111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589111.url(scheme.get, call_589111.host, call_589111.base,
                         call_589111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589111, url, valid)

proc call*(call_589112: Call_YoutubeAnalyticsReportsQuery_589090; metrics: string;
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
  var query_589113 = newJObject()
  add(query_589113, "include-historical-channel-data",
      newJBool(includeHistoricalChannelData))
  add(query_589113, "fields", newJString(fields))
  add(query_589113, "quotaUser", newJString(quotaUser))
  add(query_589113, "alt", newJString(alt))
  add(query_589113, "currency", newJString(currency))
  add(query_589113, "sort", newJString(sort))
  add(query_589113, "metrics", newJString(metrics))
  add(query_589113, "oauth_token", newJString(oauthToken))
  add(query_589113, "userIp", newJString(userIp))
  add(query_589113, "dimensions", newJString(dimensions))
  add(query_589113, "ids", newJString(ids))
  add(query_589113, "key", newJString(key))
  add(query_589113, "max-results", newJInt(maxResults))
  add(query_589113, "end-date", newJString(endDate))
  add(query_589113, "start-date", newJString(startDate))
  add(query_589113, "filters", newJString(filters))
  add(query_589113, "start-index", newJInt(startIndex))
  add(query_589113, "prettyPrint", newJBool(prettyPrint))
  result = call_589112.call(nil, query_589113, nil, nil, nil)

var youtubeAnalyticsReportsQuery* = Call_YoutubeAnalyticsReportsQuery_589090(
    name: "youtubeAnalyticsReportsQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_YoutubeAnalyticsReportsQuery_589091,
    base: "/youtube/analytics/v1beta1", url: url_YoutubeAnalyticsReportsQuery_589092,
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

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
