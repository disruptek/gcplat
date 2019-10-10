
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: YouTube Analytics
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Retrieves your YouTube Analytics data.
## 
## https://developers.google.com/youtube/analytics
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  Call_YoutubeAnalyticsGroupItemsInsert_588984 = ref object of OpenApiRestCall_588441
proc url_YoutubeAnalyticsGroupItemsInsert_588986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsInsert_588985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a group item.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588987 = query.getOrDefault("onBehalfOfContentOwner")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "onBehalfOfContentOwner", valid_588987
  var valid_588988 = query.getOrDefault("upload_protocol")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "upload_protocol", valid_588988
  var valid_588989 = query.getOrDefault("fields")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "fields", valid_588989
  var valid_588990 = query.getOrDefault("quotaUser")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "quotaUser", valid_588990
  var valid_588991 = query.getOrDefault("alt")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = newJString("json"))
  if valid_588991 != nil:
    section.add "alt", valid_588991
  var valid_588992 = query.getOrDefault("oauth_token")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "oauth_token", valid_588992
  var valid_588993 = query.getOrDefault("callback")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "callback", valid_588993
  var valid_588994 = query.getOrDefault("access_token")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "access_token", valid_588994
  var valid_588995 = query.getOrDefault("uploadType")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "uploadType", valid_588995
  var valid_588996 = query.getOrDefault("key")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "key", valid_588996
  var valid_588997 = query.getOrDefault("$.xgafv")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = newJString("1"))
  if valid_588997 != nil:
    section.add "$.xgafv", valid_588997
  var valid_588998 = query.getOrDefault("prettyPrint")
  valid_588998 = validateParameter(valid_588998, JBool, required = false,
                                 default = newJBool(true))
  if valid_588998 != nil:
    section.add "prettyPrint", valid_588998
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

proc call*(call_589000: Call_YoutubeAnalyticsGroupItemsInsert_588984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a group item.
  ## 
  let valid = call_589000.validator(path, query, header, formData, body)
  let scheme = call_589000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589000.url(scheme.get, call_589000.host, call_589000.base,
                         call_589000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589000, url, valid)

proc call*(call_589001: Call_YoutubeAnalyticsGroupItemsInsert_588984;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupItemsInsert
  ## Creates a group item.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589002 = newJObject()
  var body_589003 = newJObject()
  add(query_589002, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589002, "upload_protocol", newJString(uploadProtocol))
  add(query_589002, "fields", newJString(fields))
  add(query_589002, "quotaUser", newJString(quotaUser))
  add(query_589002, "alt", newJString(alt))
  add(query_589002, "oauth_token", newJString(oauthToken))
  add(query_589002, "callback", newJString(callback))
  add(query_589002, "access_token", newJString(accessToken))
  add(query_589002, "uploadType", newJString(uploadType))
  add(query_589002, "key", newJString(key))
  add(query_589002, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589003 = body
  add(query_589002, "prettyPrint", newJBool(prettyPrint))
  result = call_589001.call(nil, query_589002, nil, nil, body_589003)

var youtubeAnalyticsGroupItemsInsert* = Call_YoutubeAnalyticsGroupItemsInsert_588984(
    name: "youtubeAnalyticsGroupItemsInsert", meth: HttpMethod.HttpPost,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsInsert_588985, base: "/",
    url: url_YoutubeAnalyticsGroupItemsInsert_588986, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsList_588710 = ref object of OpenApiRestCall_588441
proc url_YoutubeAnalyticsGroupItemsList_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsList_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   groupId: JString
  ##          : The `groupId` parameter specifies the unique ID of the group for which you
  ## want to retrieve group items.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588824 = query.getOrDefault("onBehalfOfContentOwner")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "onBehalfOfContentOwner", valid_588824
  var valid_588825 = query.getOrDefault("upload_protocol")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "upload_protocol", valid_588825
  var valid_588826 = query.getOrDefault("fields")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "fields", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("oauth_token")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "oauth_token", valid_588842
  var valid_588843 = query.getOrDefault("callback")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "callback", valid_588843
  var valid_588844 = query.getOrDefault("access_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "access_token", valid_588844
  var valid_588845 = query.getOrDefault("uploadType")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "uploadType", valid_588845
  var valid_588846 = query.getOrDefault("groupId")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "groupId", valid_588846
  var valid_588847 = query.getOrDefault("key")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "key", valid_588847
  var valid_588848 = query.getOrDefault("$.xgafv")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = newJString("1"))
  if valid_588848 != nil:
    section.add "$.xgafv", valid_588848
  var valid_588849 = query.getOrDefault("prettyPrint")
  valid_588849 = validateParameter(valid_588849, JBool, required = false,
                                 default = newJBool(true))
  if valid_588849 != nil:
    section.add "prettyPrint", valid_588849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588872: Call_YoutubeAnalyticsGroupItemsList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  let valid = call_588872.validator(path, query, header, formData, body)
  let scheme = call_588872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588872.url(scheme.get, call_588872.host, call_588872.base,
                         call_588872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588872, url, valid)

proc call*(call_588943: Call_YoutubeAnalyticsGroupItemsList_588710;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; groupId: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupItemsList
  ## Returns a collection of group items that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   groupId: string
  ##          : The `groupId` parameter specifies the unique ID of the group for which you
  ## want to retrieve group items.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588944 = newJObject()
  add(query_588944, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_588944, "upload_protocol", newJString(uploadProtocol))
  add(query_588944, "fields", newJString(fields))
  add(query_588944, "quotaUser", newJString(quotaUser))
  add(query_588944, "alt", newJString(alt))
  add(query_588944, "oauth_token", newJString(oauthToken))
  add(query_588944, "callback", newJString(callback))
  add(query_588944, "access_token", newJString(accessToken))
  add(query_588944, "uploadType", newJString(uploadType))
  add(query_588944, "groupId", newJString(groupId))
  add(query_588944, "key", newJString(key))
  add(query_588944, "$.xgafv", newJString(Xgafv))
  add(query_588944, "prettyPrint", newJBool(prettyPrint))
  result = call_588943.call(nil, query_588944, nil, nil, nil)

var youtubeAnalyticsGroupItemsList* = Call_YoutubeAnalyticsGroupItemsList_588710(
    name: "youtubeAnalyticsGroupItemsList", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsList_588711, base: "/",
    url: url_YoutubeAnalyticsGroupItemsList_588712, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsDelete_589004 = ref object of OpenApiRestCall_588441
proc url_YoutubeAnalyticsGroupItemsDelete_589006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsDelete_589005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an item from a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: JString
  ##     : The `id` parameter specifies the YouTube group item ID of the group item
  ## that is being deleted.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589007 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "onBehalfOfContentOwner", valid_589007
  var valid_589008 = query.getOrDefault("upload_protocol")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "upload_protocol", valid_589008
  var valid_589009 = query.getOrDefault("fields")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "fields", valid_589009
  var valid_589010 = query.getOrDefault("quotaUser")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "quotaUser", valid_589010
  var valid_589011 = query.getOrDefault("id")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "id", valid_589011
  var valid_589012 = query.getOrDefault("alt")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("json"))
  if valid_589012 != nil:
    section.add "alt", valid_589012
  var valid_589013 = query.getOrDefault("oauth_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "oauth_token", valid_589013
  var valid_589014 = query.getOrDefault("callback")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "callback", valid_589014
  var valid_589015 = query.getOrDefault("access_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "access_token", valid_589015
  var valid_589016 = query.getOrDefault("uploadType")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "uploadType", valid_589016
  var valid_589017 = query.getOrDefault("key")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "key", valid_589017
  var valid_589018 = query.getOrDefault("$.xgafv")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("1"))
  if valid_589018 != nil:
    section.add "$.xgafv", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589020: Call_YoutubeAnalyticsGroupItemsDelete_589004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an item from a group.
  ## 
  let valid = call_589020.validator(path, query, header, formData, body)
  let scheme = call_589020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589020.url(scheme.get, call_589020.host, call_589020.base,
                         call_589020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589020, url, valid)

proc call*(call_589021: Call_YoutubeAnalyticsGroupItemsDelete_589004;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupItemsDelete
  ## Removes an item from a group.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: string
  ##     : The `id` parameter specifies the YouTube group item ID of the group item
  ## that is being deleted.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589022 = newJObject()
  add(query_589022, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589022, "upload_protocol", newJString(uploadProtocol))
  add(query_589022, "fields", newJString(fields))
  add(query_589022, "quotaUser", newJString(quotaUser))
  add(query_589022, "id", newJString(id))
  add(query_589022, "alt", newJString(alt))
  add(query_589022, "oauth_token", newJString(oauthToken))
  add(query_589022, "callback", newJString(callback))
  add(query_589022, "access_token", newJString(accessToken))
  add(query_589022, "uploadType", newJString(uploadType))
  add(query_589022, "key", newJString(key))
  add(query_589022, "$.xgafv", newJString(Xgafv))
  add(query_589022, "prettyPrint", newJBool(prettyPrint))
  result = call_589021.call(nil, query_589022, nil, nil, nil)

var youtubeAnalyticsGroupItemsDelete* = Call_YoutubeAnalyticsGroupItemsDelete_589004(
    name: "youtubeAnalyticsGroupItemsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsDelete_589005, base: "/",
    url: url_YoutubeAnalyticsGroupItemsDelete_589006, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsUpdate_589044 = ref object of OpenApiRestCall_588441
proc url_YoutubeAnalyticsGroupsUpdate_589046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsUpdate_589045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589047 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "onBehalfOfContentOwner", valid_589047
  var valid_589048 = query.getOrDefault("upload_protocol")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "upload_protocol", valid_589048
  var valid_589049 = query.getOrDefault("fields")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "fields", valid_589049
  var valid_589050 = query.getOrDefault("quotaUser")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "quotaUser", valid_589050
  var valid_589051 = query.getOrDefault("alt")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = newJString("json"))
  if valid_589051 != nil:
    section.add "alt", valid_589051
  var valid_589052 = query.getOrDefault("oauth_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "oauth_token", valid_589052
  var valid_589053 = query.getOrDefault("callback")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "callback", valid_589053
  var valid_589054 = query.getOrDefault("access_token")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "access_token", valid_589054
  var valid_589055 = query.getOrDefault("uploadType")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "uploadType", valid_589055
  var valid_589056 = query.getOrDefault("key")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "key", valid_589056
  var valid_589057 = query.getOrDefault("$.xgafv")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = newJString("1"))
  if valid_589057 != nil:
    section.add "$.xgafv", valid_589057
  var valid_589058 = query.getOrDefault("prettyPrint")
  valid_589058 = validateParameter(valid_589058, JBool, required = false,
                                 default = newJBool(true))
  if valid_589058 != nil:
    section.add "prettyPrint", valid_589058
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

proc call*(call_589060: Call_YoutubeAnalyticsGroupsUpdate_589044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  let valid = call_589060.validator(path, query, header, formData, body)
  let scheme = call_589060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589060.url(scheme.get, call_589060.host, call_589060.base,
                         call_589060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589060, url, valid)

proc call*(call_589061: Call_YoutubeAnalyticsGroupsUpdate_589044;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsUpdate
  ## Modifies a group. For example, you could change a group's title.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589062 = newJObject()
  var body_589063 = newJObject()
  add(query_589062, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589062, "upload_protocol", newJString(uploadProtocol))
  add(query_589062, "fields", newJString(fields))
  add(query_589062, "quotaUser", newJString(quotaUser))
  add(query_589062, "alt", newJString(alt))
  add(query_589062, "oauth_token", newJString(oauthToken))
  add(query_589062, "callback", newJString(callback))
  add(query_589062, "access_token", newJString(accessToken))
  add(query_589062, "uploadType", newJString(uploadType))
  add(query_589062, "key", newJString(key))
  add(query_589062, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589063 = body
  add(query_589062, "prettyPrint", newJBool(prettyPrint))
  result = call_589061.call(nil, query_589062, nil, nil, body_589063)

var youtubeAnalyticsGroupsUpdate* = Call_YoutubeAnalyticsGroupsUpdate_589044(
    name: "youtubeAnalyticsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsUpdate_589045, base: "/",
    url: url_YoutubeAnalyticsGroupsUpdate_589046, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsInsert_589064 = ref object of OpenApiRestCall_588441
proc url_YoutubeAnalyticsGroupsInsert_589066(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsInsert_589065(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589067 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "onBehalfOfContentOwner", valid_589067
  var valid_589068 = query.getOrDefault("upload_protocol")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "upload_protocol", valid_589068
  var valid_589069 = query.getOrDefault("fields")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "fields", valid_589069
  var valid_589070 = query.getOrDefault("quotaUser")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "quotaUser", valid_589070
  var valid_589071 = query.getOrDefault("alt")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("json"))
  if valid_589071 != nil:
    section.add "alt", valid_589071
  var valid_589072 = query.getOrDefault("oauth_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "oauth_token", valid_589072
  var valid_589073 = query.getOrDefault("callback")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "callback", valid_589073
  var valid_589074 = query.getOrDefault("access_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "access_token", valid_589074
  var valid_589075 = query.getOrDefault("uploadType")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "uploadType", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("$.xgafv")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("1"))
  if valid_589077 != nil:
    section.add "$.xgafv", valid_589077
  var valid_589078 = query.getOrDefault("prettyPrint")
  valid_589078 = validateParameter(valid_589078, JBool, required = false,
                                 default = newJBool(true))
  if valid_589078 != nil:
    section.add "prettyPrint", valid_589078
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

proc call*(call_589080: Call_YoutubeAnalyticsGroupsInsert_589064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a group.
  ## 
  let valid = call_589080.validator(path, query, header, formData, body)
  let scheme = call_589080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589080.url(scheme.get, call_589080.host, call_589080.base,
                         call_589080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589080, url, valid)

proc call*(call_589081: Call_YoutubeAnalyticsGroupsInsert_589064;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsInsert
  ## Creates a group.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589082 = newJObject()
  var body_589083 = newJObject()
  add(query_589082, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589082, "upload_protocol", newJString(uploadProtocol))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "callback", newJString(callback))
  add(query_589082, "access_token", newJString(accessToken))
  add(query_589082, "uploadType", newJString(uploadType))
  add(query_589082, "key", newJString(key))
  add(query_589082, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589083 = body
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589081.call(nil, query_589082, nil, nil, body_589083)

var youtubeAnalyticsGroupsInsert* = Call_YoutubeAnalyticsGroupsInsert_589064(
    name: "youtubeAnalyticsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsInsert_589065, base: "/",
    url: url_YoutubeAnalyticsGroupsInsert_589066, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsList_589023 = ref object of OpenApiRestCall_588441
proc url_YoutubeAnalyticsGroupsList_589025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsList_589024(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of groups that match the API request parameters. For
  ## example, you can retrieve all groups that the authenticated user owns,
  ## or you can retrieve one or more groups by their unique IDs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : This parameter can only be used in a properly authorized request. Set this
  ## parameter's value to true to retrieve all groups owned by the authenticated
  ## user.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The `pageToken` parameter identifies a specific page in the result set that
  ## should be returned. In an API response, the `nextPageToken` property
  ## identifies the next page that can be retrieved.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: JString
  ##     : The `id` parameter specifies a comma-separated list of the YouTube group
  ## ID(s) for the resource(s) that are being retrieved. Each group must be
  ## owned by the authenticated user. In a `group` resource, the `id` property
  ## specifies the group's YouTube group ID.
  ## 
  ## Note that if you do not specify a value for the `id` parameter, then you
  ## must set the `mine` parameter to `true`.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589026 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "onBehalfOfContentOwner", valid_589026
  var valid_589027 = query.getOrDefault("mine")
  valid_589027 = validateParameter(valid_589027, JBool, required = false, default = nil)
  if valid_589027 != nil:
    section.add "mine", valid_589027
  var valid_589028 = query.getOrDefault("upload_protocol")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "upload_protocol", valid_589028
  var valid_589029 = query.getOrDefault("fields")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "fields", valid_589029
  var valid_589030 = query.getOrDefault("pageToken")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "pageToken", valid_589030
  var valid_589031 = query.getOrDefault("quotaUser")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "quotaUser", valid_589031
  var valid_589032 = query.getOrDefault("id")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "id", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("callback")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "callback", valid_589035
  var valid_589036 = query.getOrDefault("access_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "access_token", valid_589036
  var valid_589037 = query.getOrDefault("uploadType")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "uploadType", valid_589037
  var valid_589038 = query.getOrDefault("key")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "key", valid_589038
  var valid_589039 = query.getOrDefault("$.xgafv")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("1"))
  if valid_589039 != nil:
    section.add "$.xgafv", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589041: Call_YoutubeAnalyticsGroupsList_589023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of groups that match the API request parameters. For
  ## example, you can retrieve all groups that the authenticated user owns,
  ## or you can retrieve one or more groups by their unique IDs.
  ## 
  let valid = call_589041.validator(path, query, header, formData, body)
  let scheme = call_589041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589041.url(scheme.get, call_589041.host, call_589041.base,
                         call_589041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589041, url, valid)

proc call*(call_589042: Call_YoutubeAnalyticsGroupsList_589023;
          onBehalfOfContentOwner: string = ""; mine: bool = false;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsList
  ## Returns a collection of groups that match the API request parameters. For
  ## example, you can retrieve all groups that the authenticated user owns,
  ## or you can retrieve one or more groups by their unique IDs.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : This parameter can only be used in a properly authorized request. Set this
  ## parameter's value to true to retrieve all groups owned by the authenticated
  ## user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The `pageToken` parameter identifies a specific page in the result set that
  ## should be returned. In an API response, the `nextPageToken` property
  ## identifies the next page that can be retrieved.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: string
  ##     : The `id` parameter specifies a comma-separated list of the YouTube group
  ## ID(s) for the resource(s) that are being retrieved. Each group must be
  ## owned by the authenticated user. In a `group` resource, the `id` property
  ## specifies the group's YouTube group ID.
  ## 
  ## Note that if you do not specify a value for the `id` parameter, then you
  ## must set the `mine` parameter to `true`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589043 = newJObject()
  add(query_589043, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589043, "mine", newJBool(mine))
  add(query_589043, "upload_protocol", newJString(uploadProtocol))
  add(query_589043, "fields", newJString(fields))
  add(query_589043, "pageToken", newJString(pageToken))
  add(query_589043, "quotaUser", newJString(quotaUser))
  add(query_589043, "id", newJString(id))
  add(query_589043, "alt", newJString(alt))
  add(query_589043, "oauth_token", newJString(oauthToken))
  add(query_589043, "callback", newJString(callback))
  add(query_589043, "access_token", newJString(accessToken))
  add(query_589043, "uploadType", newJString(uploadType))
  add(query_589043, "key", newJString(key))
  add(query_589043, "$.xgafv", newJString(Xgafv))
  add(query_589043, "prettyPrint", newJBool(prettyPrint))
  result = call_589042.call(nil, query_589043, nil, nil, nil)

var youtubeAnalyticsGroupsList* = Call_YoutubeAnalyticsGroupsList_589023(
    name: "youtubeAnalyticsGroupsList", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsList_589024, base: "/",
    url: url_YoutubeAnalyticsGroupsList_589025, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsDelete_589084 = ref object of OpenApiRestCall_588441
proc url_YoutubeAnalyticsGroupsDelete_589086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsDelete_589085(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: JString
  ##     : The `id` parameter specifies the YouTube group ID of the group that is
  ## being deleted.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589087 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "onBehalfOfContentOwner", valid_589087
  var valid_589088 = query.getOrDefault("upload_protocol")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "upload_protocol", valid_589088
  var valid_589089 = query.getOrDefault("fields")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "fields", valid_589089
  var valid_589090 = query.getOrDefault("quotaUser")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "quotaUser", valid_589090
  var valid_589091 = query.getOrDefault("id")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "id", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("callback")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "callback", valid_589094
  var valid_589095 = query.getOrDefault("access_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "access_token", valid_589095
  var valid_589096 = query.getOrDefault("uploadType")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "uploadType", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("$.xgafv")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("1"))
  if valid_589098 != nil:
    section.add "$.xgafv", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589100: Call_YoutubeAnalyticsGroupsDelete_589084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a group.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_YoutubeAnalyticsGroupsDelete_589084;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsDelete
  ## Deletes a group.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: string
  ##     : The `id` parameter specifies the YouTube group ID of the group that is
  ## being deleted.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589102 = newJObject()
  add(query_589102, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(query_589102, "id", newJString(id))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(query_589102, "key", newJString(key))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  result = call_589101.call(nil, query_589102, nil, nil, nil)

var youtubeAnalyticsGroupsDelete* = Call_YoutubeAnalyticsGroupsDelete_589084(
    name: "youtubeAnalyticsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsDelete_589085, base: "/",
    url: url_YoutubeAnalyticsGroupsDelete_589086, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsReportsQuery_589103 = ref object of OpenApiRestCall_588441
proc url_YoutubeAnalyticsReportsQuery_589105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsReportsQuery_589104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve your YouTube Analytics reports.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   endDate: JString
  ##          : The end date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: [0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   currency: JString
  ##           : The currency to which financial metrics should be converted. The default is
  ## US Dollar (USD). If the result contains no financial metrics, this flag
  ## will be ignored. Responds with an error if the specified currency is not
  ## recognized.",
  ## pattern: [A-Z]{3}
  ##   startDate: JString
  ##            : The start date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort
  ## order for YouTube Analytics data. By default the sort order is ascending.
  ## The '`-`' prefix causes descending sort order.",
  ## pattern: [-0-9a-zA-Z,]+
  ##   metrics: JString
  ##          : A comma-separated list of YouTube Analytics metrics, such as `views` or
  ## `likes,dislikes`. See the
  ## [Available Reports](/youtube/analytics/v2/available_reports)  document for
  ## a list of the reports that you can retrieve and the metrics
  ## available in each report, and see the
  ## [Metrics](/youtube/analytics/v2/dimsmets/mets) document for definitions of
  ## those metrics.
  ## required: true, pattern: [0-9a-zA-Z,]+
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maxResults: JInt
  ##             : The maximum number of rows to include in the response.",
  ## minValue: 1
  ##   dimensions: JString
  ##             : A comma-separated list of YouTube Analytics dimensions, such as `views` or
  ## `ageGroup,gender`. See the [Available
  ## Reports](/youtube/analytics/v2/available_reports) document for a list of
  ## the reports that you can retrieve and the dimensions used for those
  ## reports. Also see the [Dimensions](/youtube/analytics/v2/dimsmets/dims)
  ## document for definitions of those dimensions."
  ## pattern: [0-9a-zA-Z,]+
  ##   ids: JString
  ##      : Identifies the YouTube channel or content owner for which you are
  ## retrieving YouTube Analytics data.
  ## 
  ## - To request data for a YouTube user, set the `ids` parameter value to
  ##   `channel==CHANNEL_ID`, where `CHANNEL_ID` specifies the unique YouTube
  ##   channel ID.
  ## - To request data for a YouTube CMS content owner, set the `ids` parameter
  ##   value to `contentOwner==OWNER_NAME`, where `OWNER_NAME` is the CMS name
  ##   of the content owner.
  ## required: true, pattern: [a-zA-Z]+==[a-zA-Z0-9_+-]+
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeHistoricalChannelData: JBool
  ##                               : If set to true historical data (i.e. channel data from before the linking
  ## of the channel to the content owner) will be retrieved.",
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   filters: JString
  ##          : A list of filters that should be applied when retrieving YouTube Analytics
  ## data. The [Available Reports](/youtube/analytics/v2/available_reports)
  ## document identifies the dimensions that can be used to filter each report,
  ## and the [Dimensions](/youtube/analytics/v2/dimsmets/dims)  document defines
  ## those dimensions. If a request uses multiple filters, join them together
  ## with a semicolon (`;`), and the returned result table will satisfy both
  ## filters. For example, a filters parameter value of
  ## `video==dMH0bHeiRNg;country==IT` restricts the result set to include data
  ## for the given video in Italy.",
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : An index of the first entity to retrieve. Use this parameter as a
  ## pagination mechanism along with the max-results parameter (one-based,
  ## inclusive).",
  ## minValue: 1
  section = newJObject()
  var valid_589106 = query.getOrDefault("upload_protocol")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "upload_protocol", valid_589106
  var valid_589107 = query.getOrDefault("fields")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "fields", valid_589107
  var valid_589108 = query.getOrDefault("quotaUser")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "quotaUser", valid_589108
  var valid_589109 = query.getOrDefault("alt")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = newJString("json"))
  if valid_589109 != nil:
    section.add "alt", valid_589109
  var valid_589110 = query.getOrDefault("endDate")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "endDate", valid_589110
  var valid_589111 = query.getOrDefault("currency")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "currency", valid_589111
  var valid_589112 = query.getOrDefault("startDate")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "startDate", valid_589112
  var valid_589113 = query.getOrDefault("sort")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "sort", valid_589113
  var valid_589114 = query.getOrDefault("metrics")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "metrics", valid_589114
  var valid_589115 = query.getOrDefault("oauth_token")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "oauth_token", valid_589115
  var valid_589116 = query.getOrDefault("callback")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "callback", valid_589116
  var valid_589117 = query.getOrDefault("access_token")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "access_token", valid_589117
  var valid_589118 = query.getOrDefault("uploadType")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "uploadType", valid_589118
  var valid_589119 = query.getOrDefault("maxResults")
  valid_589119 = validateParameter(valid_589119, JInt, required = false, default = nil)
  if valid_589119 != nil:
    section.add "maxResults", valid_589119
  var valid_589120 = query.getOrDefault("dimensions")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "dimensions", valid_589120
  var valid_589121 = query.getOrDefault("ids")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "ids", valid_589121
  var valid_589122 = query.getOrDefault("key")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "key", valid_589122
  var valid_589123 = query.getOrDefault("includeHistoricalChannelData")
  valid_589123 = validateParameter(valid_589123, JBool, required = false, default = nil)
  if valid_589123 != nil:
    section.add "includeHistoricalChannelData", valid_589123
  var valid_589124 = query.getOrDefault("$.xgafv")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = newJString("1"))
  if valid_589124 != nil:
    section.add "$.xgafv", valid_589124
  var valid_589125 = query.getOrDefault("filters")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "filters", valid_589125
  var valid_589126 = query.getOrDefault("prettyPrint")
  valid_589126 = validateParameter(valid_589126, JBool, required = false,
                                 default = newJBool(true))
  if valid_589126 != nil:
    section.add "prettyPrint", valid_589126
  var valid_589127 = query.getOrDefault("startIndex")
  valid_589127 = validateParameter(valid_589127, JInt, required = false, default = nil)
  if valid_589127 != nil:
    section.add "startIndex", valid_589127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589128: Call_YoutubeAnalyticsReportsQuery_589103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve your YouTube Analytics reports.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_YoutubeAnalyticsReportsQuery_589103;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; endDate: string = ""; currency: string = "";
          startDate: string = ""; sort: string = ""; metrics: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; maxResults: int = 0; dimensions: string = "";
          ids: string = ""; key: string = "";
          includeHistoricalChannelData: bool = false; Xgafv: string = "1";
          filters: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## youtubeAnalyticsReportsQuery
  ## Retrieve your YouTube Analytics reports.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   endDate: string
  ##          : The end date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: [0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   currency: string
  ##           : The currency to which financial metrics should be converted. The default is
  ## US Dollar (USD). If the result contains no financial metrics, this flag
  ## will be ignored. Responds with an error if the specified currency is not
  ## recognized.",
  ## pattern: [A-Z]{3}
  ##   startDate: string
  ##            : The start date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort
  ## order for YouTube Analytics data. By default the sort order is ascending.
  ## The '`-`' prefix causes descending sort order.",
  ## pattern: [-0-9a-zA-Z,]+
  ##   metrics: string
  ##          : A comma-separated list of YouTube Analytics metrics, such as `views` or
  ## `likes,dislikes`. See the
  ## [Available Reports](/youtube/analytics/v2/available_reports)  document for
  ## a list of the reports that you can retrieve and the metrics
  ## available in each report, and see the
  ## [Metrics](/youtube/analytics/v2/dimsmets/mets) document for definitions of
  ## those metrics.
  ## required: true, pattern: [0-9a-zA-Z,]+
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maxResults: int
  ##             : The maximum number of rows to include in the response.",
  ## minValue: 1
  ##   dimensions: string
  ##             : A comma-separated list of YouTube Analytics dimensions, such as `views` or
  ## `ageGroup,gender`. See the [Available
  ## Reports](/youtube/analytics/v2/available_reports) document for a list of
  ## the reports that you can retrieve and the dimensions used for those
  ## reports. Also see the [Dimensions](/youtube/analytics/v2/dimsmets/dims)
  ## document for definitions of those dimensions."
  ## pattern: [0-9a-zA-Z,]+
  ##   ids: string
  ##      : Identifies the YouTube channel or content owner for which you are
  ## retrieving YouTube Analytics data.
  ## 
  ## - To request data for a YouTube user, set the `ids` parameter value to
  ##   `channel==CHANNEL_ID`, where `CHANNEL_ID` specifies the unique YouTube
  ##   channel ID.
  ## - To request data for a YouTube CMS content owner, set the `ids` parameter
  ##   value to `contentOwner==OWNER_NAME`, where `OWNER_NAME` is the CMS name
  ##   of the content owner.
  ## required: true, pattern: [a-zA-Z]+==[a-zA-Z0-9_+-]+
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeHistoricalChannelData: bool
  ##                               : If set to true historical data (i.e. channel data from before the linking
  ## of the channel to the content owner) will be retrieved.",
  ##   Xgafv: string
  ##        : V1 error format.
  ##   filters: string
  ##          : A list of filters that should be applied when retrieving YouTube Analytics
  ## data. The [Available Reports](/youtube/analytics/v2/available_reports)
  ## document identifies the dimensions that can be used to filter each report,
  ## and the [Dimensions](/youtube/analytics/v2/dimsmets/dims)  document defines
  ## those dimensions. If a request uses multiple filters, join them together
  ## with a semicolon (`;`), and the returned result table will satisfy both
  ## filters. For example, a filters parameter value of
  ## `video==dMH0bHeiRNg;country==IT` restricts the result set to include data
  ## for the given video in Italy.",
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a
  ## pagination mechanism along with the max-results parameter (one-based,
  ## inclusive).",
  ## minValue: 1
  var query_589130 = newJObject()
  add(query_589130, "upload_protocol", newJString(uploadProtocol))
  add(query_589130, "fields", newJString(fields))
  add(query_589130, "quotaUser", newJString(quotaUser))
  add(query_589130, "alt", newJString(alt))
  add(query_589130, "endDate", newJString(endDate))
  add(query_589130, "currency", newJString(currency))
  add(query_589130, "startDate", newJString(startDate))
  add(query_589130, "sort", newJString(sort))
  add(query_589130, "metrics", newJString(metrics))
  add(query_589130, "oauth_token", newJString(oauthToken))
  add(query_589130, "callback", newJString(callback))
  add(query_589130, "access_token", newJString(accessToken))
  add(query_589130, "uploadType", newJString(uploadType))
  add(query_589130, "maxResults", newJInt(maxResults))
  add(query_589130, "dimensions", newJString(dimensions))
  add(query_589130, "ids", newJString(ids))
  add(query_589130, "key", newJString(key))
  add(query_589130, "includeHistoricalChannelData",
      newJBool(includeHistoricalChannelData))
  add(query_589130, "$.xgafv", newJString(Xgafv))
  add(query_589130, "filters", newJString(filters))
  add(query_589130, "prettyPrint", newJBool(prettyPrint))
  add(query_589130, "startIndex", newJInt(startIndex))
  result = call_589129.call(nil, query_589130, nil, nil, nil)

var youtubeAnalyticsReportsQuery* = Call_YoutubeAnalyticsReportsQuery_589103(
    name: "youtubeAnalyticsReportsQuery", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/reports",
    validator: validate_YoutubeAnalyticsReportsQuery_589104, base: "/",
    url: url_YoutubeAnalyticsReportsQuery_589105, schemes: {Scheme.Https})
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
