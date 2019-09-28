
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: People
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides access to information about profiles and contacts.
## 
## https://developers.google.com/people/
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "people"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PeopleContactGroupsCreate_579965 = ref object of OpenApiRestCall_579421
proc url_PeopleContactGroupsCreate_579967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsCreate_579966(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new contact group owned by the authenticated user.
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
  var valid_579968 = query.getOrDefault("upload_protocol")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "upload_protocol", valid_579968
  var valid_579969 = query.getOrDefault("fields")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "fields", valid_579969
  var valid_579970 = query.getOrDefault("quotaUser")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "quotaUser", valid_579970
  var valid_579971 = query.getOrDefault("alt")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = newJString("json"))
  if valid_579971 != nil:
    section.add "alt", valid_579971
  var valid_579972 = query.getOrDefault("oauth_token")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "oauth_token", valid_579972
  var valid_579973 = query.getOrDefault("callback")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "callback", valid_579973
  var valid_579974 = query.getOrDefault("access_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "access_token", valid_579974
  var valid_579975 = query.getOrDefault("uploadType")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "uploadType", valid_579975
  var valid_579976 = query.getOrDefault("key")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "key", valid_579976
  var valid_579977 = query.getOrDefault("$.xgafv")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = newJString("1"))
  if valid_579977 != nil:
    section.add "$.xgafv", valid_579977
  var valid_579978 = query.getOrDefault("prettyPrint")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "prettyPrint", valid_579978
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

proc call*(call_579980: Call_PeopleContactGroupsCreate_579965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact group owned by the authenticated user.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_PeopleContactGroupsCreate_579965;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## peopleContactGroupsCreate
  ## Create a new contact group owned by the authenticated user.
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
  var query_579982 = newJObject()
  var body_579983 = newJObject()
  add(query_579982, "upload_protocol", newJString(uploadProtocol))
  add(query_579982, "fields", newJString(fields))
  add(query_579982, "quotaUser", newJString(quotaUser))
  add(query_579982, "alt", newJString(alt))
  add(query_579982, "oauth_token", newJString(oauthToken))
  add(query_579982, "callback", newJString(callback))
  add(query_579982, "access_token", newJString(accessToken))
  add(query_579982, "uploadType", newJString(uploadType))
  add(query_579982, "key", newJString(key))
  add(query_579982, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579983 = body
  add(query_579982, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(nil, query_579982, nil, nil, body_579983)

var peopleContactGroupsCreate* = Call_PeopleContactGroupsCreate_579965(
    name: "peopleContactGroupsCreate", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsCreate_579966, base: "/",
    url: url_PeopleContactGroupsCreate_579967, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsList_579690 = ref object of OpenApiRestCall_579421
proc url_PeopleContactGroupsList_579692(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsList_579691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
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
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous call to
  ## [ListContactGroups](/people/api/rest/v1/contactgroups/list).
  ## Requests the next page of resources.
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
  ##   syncToken: JString
  ##            : A sync token, returned by a previous call to `contactgroups.list`.
  ## Only resources changed since the sync token was created will be returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of resources to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("pageToken")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "pageToken", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("callback")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "callback", valid_579823
  var valid_579824 = query.getOrDefault("access_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "access_token", valid_579824
  var valid_579825 = query.getOrDefault("uploadType")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "uploadType", valid_579825
  var valid_579826 = query.getOrDefault("syncToken")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "syncToken", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("pageSize")
  valid_579829 = validateParameter(valid_579829, JInt, required = false, default = nil)
  if valid_579829 != nil:
    section.add "pageSize", valid_579829
  var valid_579830 = query.getOrDefault("prettyPrint")
  valid_579830 = validateParameter(valid_579830, JBool, required = false,
                                 default = newJBool(true))
  if valid_579830 != nil:
    section.add "prettyPrint", valid_579830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579853: Call_PeopleContactGroupsList_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
  ## 
  let valid = call_579853.validator(path, query, header, formData, body)
  let scheme = call_579853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579853.url(scheme.get, call_579853.host, call_579853.base,
                         call_579853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579853, url, valid)

proc call*(call_579924: Call_PeopleContactGroupsList_579690;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          syncToken: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## peopleContactGroupsList
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous call to
  ## [ListContactGroups](/people/api/rest/v1/contactgroups/list).
  ## Requests the next page of resources.
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
  ##   syncToken: string
  ##            : A sync token, returned by a previous call to `contactgroups.list`.
  ## Only resources changed since the sync token was created will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of resources to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579925 = newJObject()
  add(query_579925, "upload_protocol", newJString(uploadProtocol))
  add(query_579925, "fields", newJString(fields))
  add(query_579925, "pageToken", newJString(pageToken))
  add(query_579925, "quotaUser", newJString(quotaUser))
  add(query_579925, "alt", newJString(alt))
  add(query_579925, "oauth_token", newJString(oauthToken))
  add(query_579925, "callback", newJString(callback))
  add(query_579925, "access_token", newJString(accessToken))
  add(query_579925, "uploadType", newJString(uploadType))
  add(query_579925, "syncToken", newJString(syncToken))
  add(query_579925, "key", newJString(key))
  add(query_579925, "$.xgafv", newJString(Xgafv))
  add(query_579925, "pageSize", newJInt(pageSize))
  add(query_579925, "prettyPrint", newJBool(prettyPrint))
  result = call_579924.call(nil, query_579925, nil, nil, nil)

var peopleContactGroupsList* = Call_PeopleContactGroupsList_579690(
    name: "peopleContactGroupsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsList_579691, base: "/",
    url: url_PeopleContactGroupsList_579692, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsBatchGet_579984 = ref object of OpenApiRestCall_579421
proc url_PeopleContactGroupsBatchGet_579986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsBatchGet_579985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
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
  ##   maxMembers: JInt
  ##             : Specifies the maximum number of members to return for each group.
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
  ##   resourceNames: JArray
  ##                : The resource names of the contact groups to get.
  section = newJObject()
  var valid_579987 = query.getOrDefault("upload_protocol")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "upload_protocol", valid_579987
  var valid_579988 = query.getOrDefault("fields")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "fields", valid_579988
  var valid_579989 = query.getOrDefault("maxMembers")
  valid_579989 = validateParameter(valid_579989, JInt, required = false, default = nil)
  if valid_579989 != nil:
    section.add "maxMembers", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("resourceNames")
  valid_579999 = validateParameter(valid_579999, JArray, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "resourceNames", valid_579999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580000: Call_PeopleContactGroupsBatchGet_579984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
  ## 
  let valid = call_580000.validator(path, query, header, formData, body)
  let scheme = call_580000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580000.url(scheme.get, call_580000.host, call_580000.base,
                         call_580000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580000, url, valid)

proc call*(call_580001: Call_PeopleContactGroupsBatchGet_579984;
          uploadProtocol: string = ""; fields: string = ""; maxMembers: int = 0;
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          resourceNames: JsonNode = nil): Recallable =
  ## peopleContactGroupsBatchGet
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxMembers: int
  ##             : Specifies the maximum number of members to return for each group.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceNames: JArray
  ##                : The resource names of the contact groups to get.
  var query_580002 = newJObject()
  add(query_580002, "upload_protocol", newJString(uploadProtocol))
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "maxMembers", newJInt(maxMembers))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "callback", newJString(callback))
  add(query_580002, "access_token", newJString(accessToken))
  add(query_580002, "uploadType", newJString(uploadType))
  add(query_580002, "key", newJString(key))
  add(query_580002, "$.xgafv", newJString(Xgafv))
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  if resourceNames != nil:
    query_580002.add "resourceNames", resourceNames
  result = call_580001.call(nil, query_580002, nil, nil, nil)

var peopleContactGroupsBatchGet* = Call_PeopleContactGroupsBatchGet_579984(
    name: "peopleContactGroupsBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups:batchGet",
    validator: validate_PeopleContactGroupsBatchGet_579985, base: "/",
    url: url_PeopleContactGroupsBatchGet_579986, schemes: {Scheme.Https})
type
  Call_PeoplePeopleGetBatchGet_580003 = ref object of OpenApiRestCall_579421
proc url_PeoplePeopleGetBatchGet_580005(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeoplePeopleGetBatchGet_580004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMask.includeField: JString
  ##                           : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   personFields: JString
  ##               : **Required.** A field mask to restrict which fields on each person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   resourceNames: JArray
  ##                : The resource names of the people to provide information about.
  ## 
  ## - To get information about the authenticated user, specify `people/me`.
  ## - To get information about a google account, specify
  ##   `people/`<var>account_id</var>.
  ## - To get information about a contact, specify the resource name that
  ##   identifies the contact as returned by
  ## [`people.connections.list`](/people/api/rest/v1/people.connections/list).
  ## 
  ## You can include up to 50 resource names in one request.
  section = newJObject()
  var valid_580006 = query.getOrDefault("upload_protocol")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "upload_protocol", valid_580006
  var valid_580007 = query.getOrDefault("fields")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "fields", valid_580007
  var valid_580008 = query.getOrDefault("quotaUser")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "quotaUser", valid_580008
  var valid_580009 = query.getOrDefault("alt")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("json"))
  if valid_580009 != nil:
    section.add "alt", valid_580009
  var valid_580010 = query.getOrDefault("oauth_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "oauth_token", valid_580010
  var valid_580011 = query.getOrDefault("callback")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "callback", valid_580011
  var valid_580012 = query.getOrDefault("access_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "access_token", valid_580012
  var valid_580013 = query.getOrDefault("uploadType")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "uploadType", valid_580013
  var valid_580014 = query.getOrDefault("requestMask.includeField")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "requestMask.includeField", valid_580014
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("$.xgafv")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("1"))
  if valid_580016 != nil:
    section.add "$.xgafv", valid_580016
  var valid_580017 = query.getOrDefault("personFields")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "personFields", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
  var valid_580019 = query.getOrDefault("resourceNames")
  valid_580019 = validateParameter(valid_580019, JArray, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "resourceNames", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_PeoplePeopleGetBatchGet_580003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_PeoplePeopleGetBatchGet_580003;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          requestMaskIncludeField: string = ""; key: string = ""; Xgafv: string = "1";
          personFields: string = ""; prettyPrint: bool = true;
          resourceNames: JsonNode = nil): Recallable =
  ## peoplePeopleGetBatchGet
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
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
  ##   requestMaskIncludeField: string
  ##                          : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   personFields: string
  ##               : **Required.** A field mask to restrict which fields on each person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceNames: JArray
  ##                : The resource names of the people to provide information about.
  ## 
  ## - To get information about the authenticated user, specify `people/me`.
  ## - To get information about a google account, specify
  ##   `people/`<var>account_id</var>.
  ## - To get information about a contact, specify the resource name that
  ##   identifies the contact as returned by
  ## [`people.connections.list`](/people/api/rest/v1/people.connections/list).
  ## 
  ## You can include up to 50 resource names in one request.
  var query_580022 = newJObject()
  add(query_580022, "upload_protocol", newJString(uploadProtocol))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "callback", newJString(callback))
  add(query_580022, "access_token", newJString(accessToken))
  add(query_580022, "uploadType", newJString(uploadType))
  add(query_580022, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_580022, "key", newJString(key))
  add(query_580022, "$.xgafv", newJString(Xgafv))
  add(query_580022, "personFields", newJString(personFields))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  if resourceNames != nil:
    query_580022.add "resourceNames", resourceNames
  result = call_580021.call(nil, query_580022, nil, nil, nil)

var peoplePeopleGetBatchGet* = Call_PeoplePeopleGetBatchGet_580003(
    name: "peoplePeopleGetBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/people:batchGet",
    validator: validate_PeoplePeopleGetBatchGet_580004, base: "/",
    url: url_PeoplePeopleGetBatchGet_580005, schemes: {Scheme.Https})
type
  Call_PeoplePeopleCreateContact_580023 = ref object of OpenApiRestCall_579421
proc url_PeoplePeopleCreateContact_580025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeoplePeopleCreateContact_580024(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new contact and return the person resource for that contact.
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The resource name of the owning person resource.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580026 = query.getOrDefault("upload_protocol")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "upload_protocol", valid_580026
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("callback")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "callback", valid_580031
  var valid_580032 = query.getOrDefault("access_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "access_token", valid_580032
  var valid_580033 = query.getOrDefault("uploadType")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "uploadType", valid_580033
  var valid_580034 = query.getOrDefault("parent")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "parent", valid_580034
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("$.xgafv")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("1"))
  if valid_580036 != nil:
    section.add "$.xgafv", valid_580036
  var valid_580037 = query.getOrDefault("prettyPrint")
  valid_580037 = validateParameter(valid_580037, JBool, required = false,
                                 default = newJBool(true))
  if valid_580037 != nil:
    section.add "prettyPrint", valid_580037
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

proc call*(call_580039: Call_PeoplePeopleCreateContact_580023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact and return the person resource for that contact.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_PeoplePeopleCreateContact_580023;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; parent: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## peoplePeopleCreateContact
  ## Create a new contact and return the person resource for that contact.
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
  ##   parent: string
  ##         : The resource name of the owning person resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580041 = newJObject()
  var body_580042 = newJObject()
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "parent", newJString(parent))
  add(query_580041, "key", newJString(key))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580042 = body
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  result = call_580040.call(nil, query_580041, nil, nil, body_580042)

var peoplePeopleCreateContact* = Call_PeoplePeopleCreateContact_580023(
    name: "peoplePeopleCreateContact", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/people:createContact",
    validator: validate_PeoplePeopleCreateContact_580024, base: "/",
    url: url_PeoplePeopleCreateContact_580025, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsUpdate_580078 = ref object of OpenApiRestCall_579421
proc url_PeopleContactGroupsUpdate_580080(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsUpdate_580079(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name for the contact group, assigned by the server. An ASCII
  ## string, in the form of `contactGroups/`<var>contact_group_id</var>.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580081 = path.getOrDefault("resourceName")
  valid_580081 = validateParameter(valid_580081, JString, required = true,
                                 default = nil)
  if valid_580081 != nil:
    section.add "resourceName", valid_580081
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
  var valid_580082 = query.getOrDefault("upload_protocol")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "upload_protocol", valid_580082
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  var valid_580084 = query.getOrDefault("quotaUser")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "quotaUser", valid_580084
  var valid_580085 = query.getOrDefault("alt")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = newJString("json"))
  if valid_580085 != nil:
    section.add "alt", valid_580085
  var valid_580086 = query.getOrDefault("oauth_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "oauth_token", valid_580086
  var valid_580087 = query.getOrDefault("callback")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "callback", valid_580087
  var valid_580088 = query.getOrDefault("access_token")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "access_token", valid_580088
  var valid_580089 = query.getOrDefault("uploadType")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "uploadType", valid_580089
  var valid_580090 = query.getOrDefault("key")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "key", valid_580090
  var valid_580091 = query.getOrDefault("$.xgafv")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = newJString("1"))
  if valid_580091 != nil:
    section.add "$.xgafv", valid_580091
  var valid_580092 = query.getOrDefault("prettyPrint")
  valid_580092 = validateParameter(valid_580092, JBool, required = false,
                                 default = newJBool(true))
  if valid_580092 != nil:
    section.add "prettyPrint", valid_580092
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

proc call*(call_580094: Call_PeopleContactGroupsUpdate_580078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
  ## 
  let valid = call_580094.validator(path, query, header, formData, body)
  let scheme = call_580094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580094.url(scheme.get, call_580094.host, call_580094.base,
                         call_580094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580094, url, valid)

proc call*(call_580095: Call_PeopleContactGroupsUpdate_580078;
          resourceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## peopleContactGroupsUpdate
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
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
  ##   resourceName: string (required)
  ##               : The resource name for the contact group, assigned by the server. An ASCII
  ## string, in the form of `contactGroups/`<var>contact_group_id</var>.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580096 = newJObject()
  var query_580097 = newJObject()
  var body_580098 = newJObject()
  add(query_580097, "upload_protocol", newJString(uploadProtocol))
  add(query_580097, "fields", newJString(fields))
  add(query_580097, "quotaUser", newJString(quotaUser))
  add(query_580097, "alt", newJString(alt))
  add(query_580097, "oauth_token", newJString(oauthToken))
  add(query_580097, "callback", newJString(callback))
  add(query_580097, "access_token", newJString(accessToken))
  add(query_580097, "uploadType", newJString(uploadType))
  add(path_580096, "resourceName", newJString(resourceName))
  add(query_580097, "key", newJString(key))
  add(query_580097, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580098 = body
  add(query_580097, "prettyPrint", newJBool(prettyPrint))
  result = call_580095.call(path_580096, query_580097, nil, nil, body_580098)

var peopleContactGroupsUpdate* = Call_PeopleContactGroupsUpdate_580078(
    name: "peopleContactGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsUpdate_580079, base: "/",
    url: url_PeopleContactGroupsUpdate_580080, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsGet_580043 = ref object of OpenApiRestCall_579421
proc url_PeopleContactGroupsGet_580045(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsGet_580044(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact group to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580060 = path.getOrDefault("resourceName")
  valid_580060 = validateParameter(valid_580060, JString, required = true,
                                 default = nil)
  if valid_580060 != nil:
    section.add "resourceName", valid_580060
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxMembers: JInt
  ##             : Specifies the maximum number of members to return.
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
  ##   requestMask.includeField: JString
  ##                           : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580061 = query.getOrDefault("upload_protocol")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "upload_protocol", valid_580061
  var valid_580062 = query.getOrDefault("fields")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "fields", valid_580062
  var valid_580063 = query.getOrDefault("maxMembers")
  valid_580063 = validateParameter(valid_580063, JInt, required = false, default = nil)
  if valid_580063 != nil:
    section.add "maxMembers", valid_580063
  var valid_580064 = query.getOrDefault("quotaUser")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "quotaUser", valid_580064
  var valid_580065 = query.getOrDefault("alt")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("json"))
  if valid_580065 != nil:
    section.add "alt", valid_580065
  var valid_580066 = query.getOrDefault("oauth_token")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "oauth_token", valid_580066
  var valid_580067 = query.getOrDefault("callback")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "callback", valid_580067
  var valid_580068 = query.getOrDefault("access_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "access_token", valid_580068
  var valid_580069 = query.getOrDefault("uploadType")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "uploadType", valid_580069
  var valid_580070 = query.getOrDefault("requestMask.includeField")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "requestMask.includeField", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("$.xgafv")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("1"))
  if valid_580072 != nil:
    section.add "$.xgafv", valid_580072
  var valid_580073 = query.getOrDefault("prettyPrint")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(true))
  if valid_580073 != nil:
    section.add "prettyPrint", valid_580073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580074: Call_PeopleContactGroupsGet_580043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ## 
  let valid = call_580074.validator(path, query, header, formData, body)
  let scheme = call_580074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580074.url(scheme.get, call_580074.host, call_580074.base,
                         call_580074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580074, url, valid)

proc call*(call_580075: Call_PeopleContactGroupsGet_580043; resourceName: string;
          uploadProtocol: string = ""; fields: string = ""; maxMembers: int = 0;
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          requestMaskIncludeField: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## peopleContactGroupsGet
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxMembers: int
  ##             : Specifies the maximum number of members to return.
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
  ##   requestMaskIncludeField: string
  ##                          : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   resourceName: string (required)
  ##               : The resource name of the contact group to get.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580076 = newJObject()
  var query_580077 = newJObject()
  add(query_580077, "upload_protocol", newJString(uploadProtocol))
  add(query_580077, "fields", newJString(fields))
  add(query_580077, "maxMembers", newJInt(maxMembers))
  add(query_580077, "quotaUser", newJString(quotaUser))
  add(query_580077, "alt", newJString(alt))
  add(query_580077, "oauth_token", newJString(oauthToken))
  add(query_580077, "callback", newJString(callback))
  add(query_580077, "access_token", newJString(accessToken))
  add(query_580077, "uploadType", newJString(uploadType))
  add(query_580077, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(path_580076, "resourceName", newJString(resourceName))
  add(query_580077, "key", newJString(key))
  add(query_580077, "$.xgafv", newJString(Xgafv))
  add(query_580077, "prettyPrint", newJBool(prettyPrint))
  result = call_580075.call(path_580076, query_580077, nil, nil, nil)

var peopleContactGroupsGet* = Call_PeopleContactGroupsGet_580043(
    name: "peopleContactGroupsGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsGet_580044, base: "/",
    url: url_PeopleContactGroupsGet_580045, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsDelete_580099 = ref object of OpenApiRestCall_579421
proc url_PeopleContactGroupsDelete_580101(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsDelete_580100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact group to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580102 = path.getOrDefault("resourceName")
  valid_580102 = validateParameter(valid_580102, JString, required = true,
                                 default = nil)
  if valid_580102 != nil:
    section.add "resourceName", valid_580102
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   deleteContacts: JBool
  ##                 : Set to true to also delete the contacts in the specified group.
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
  var valid_580103 = query.getOrDefault("upload_protocol")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "upload_protocol", valid_580103
  var valid_580104 = query.getOrDefault("deleteContacts")
  valid_580104 = validateParameter(valid_580104, JBool, required = false, default = nil)
  if valid_580104 != nil:
    section.add "deleteContacts", valid_580104
  var valid_580105 = query.getOrDefault("fields")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "fields", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("callback")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "callback", valid_580109
  var valid_580110 = query.getOrDefault("access_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "access_token", valid_580110
  var valid_580111 = query.getOrDefault("uploadType")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "uploadType", valid_580111
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("$.xgafv")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("1"))
  if valid_580113 != nil:
    section.add "$.xgafv", valid_580113
  var valid_580114 = query.getOrDefault("prettyPrint")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "prettyPrint", valid_580114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580115: Call_PeopleContactGroupsDelete_580099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ## 
  let valid = call_580115.validator(path, query, header, formData, body)
  let scheme = call_580115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580115.url(scheme.get, call_580115.host, call_580115.base,
                         call_580115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580115, url, valid)

proc call*(call_580116: Call_PeopleContactGroupsDelete_580099;
          resourceName: string; uploadProtocol: string = "";
          deleteContacts: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## peopleContactGroupsDelete
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   deleteContacts: bool
  ##                 : Set to true to also delete the contacts in the specified group.
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
  ##   resourceName: string (required)
  ##               : The resource name of the contact group to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580117 = newJObject()
  var query_580118 = newJObject()
  add(query_580118, "upload_protocol", newJString(uploadProtocol))
  add(query_580118, "deleteContacts", newJBool(deleteContacts))
  add(query_580118, "fields", newJString(fields))
  add(query_580118, "quotaUser", newJString(quotaUser))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "callback", newJString(callback))
  add(query_580118, "access_token", newJString(accessToken))
  add(query_580118, "uploadType", newJString(uploadType))
  add(path_580117, "resourceName", newJString(resourceName))
  add(query_580118, "key", newJString(key))
  add(query_580118, "$.xgafv", newJString(Xgafv))
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  result = call_580116.call(path_580117, query_580118, nil, nil, nil)

var peopleContactGroupsDelete* = Call_PeopleContactGroupsDelete_580099(
    name: "peopleContactGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsDelete_580100, base: "/",
    url: url_PeopleContactGroupsDelete_580101, schemes: {Scheme.Https})
type
  Call_PeoplePeopleConnectionsList_580119 = ref object of OpenApiRestCall_579421
proc url_PeoplePeopleConnectionsList_580121(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleConnectionsList_580120(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name to return connections for. Only `people/me` is valid.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580122 = path.getOrDefault("resourceName")
  valid_580122 = validateParameter(valid_580122, JString, required = true,
                                 default = nil)
  if valid_580122 != nil:
    section.add "resourceName", valid_580122
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token of the page to be returned.
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
  ##   requestMask.includeField: JString
  ##                           : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   syncToken: JString
  ##            : A sync token returned by a previous call to `people.connections.list`.
  ## Only resources changed since the sync token was created will be returned.
  ## Sync requests that specify `sync_token` have an additional rate limit.
  ##   requestSyncToken: JBool
  ##                   : Whether the response should include a sync token, which can be used to get
  ## all changes since the last request. For subsequent sync requests use the
  ## `sync_token` param instead. Initial sync requests that specify
  ## `request_sync_token` have an additional rate limit.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The number of connections to include in the response. Valid values are
  ## between 1 and 2000, inclusive. Defaults to 100.
  ##   sortOrder: JString
  ##            : The order in which the connections should be sorted. Defaults to
  ## `LAST_MODIFIED_ASCENDING`.
  ##   personFields: JString
  ##               : **Required.** A field mask to restrict which fields on each person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580123 = query.getOrDefault("upload_protocol")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "upload_protocol", valid_580123
  var valid_580124 = query.getOrDefault("fields")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "fields", valid_580124
  var valid_580125 = query.getOrDefault("pageToken")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "pageToken", valid_580125
  var valid_580126 = query.getOrDefault("quotaUser")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "quotaUser", valid_580126
  var valid_580127 = query.getOrDefault("alt")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("json"))
  if valid_580127 != nil:
    section.add "alt", valid_580127
  var valid_580128 = query.getOrDefault("oauth_token")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "oauth_token", valid_580128
  var valid_580129 = query.getOrDefault("callback")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "callback", valid_580129
  var valid_580130 = query.getOrDefault("access_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "access_token", valid_580130
  var valid_580131 = query.getOrDefault("uploadType")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "uploadType", valid_580131
  var valid_580132 = query.getOrDefault("requestMask.includeField")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "requestMask.includeField", valid_580132
  var valid_580133 = query.getOrDefault("syncToken")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "syncToken", valid_580133
  var valid_580134 = query.getOrDefault("requestSyncToken")
  valid_580134 = validateParameter(valid_580134, JBool, required = false, default = nil)
  if valid_580134 != nil:
    section.add "requestSyncToken", valid_580134
  var valid_580135 = query.getOrDefault("key")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "key", valid_580135
  var valid_580136 = query.getOrDefault("$.xgafv")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("1"))
  if valid_580136 != nil:
    section.add "$.xgafv", valid_580136
  var valid_580137 = query.getOrDefault("pageSize")
  valid_580137 = validateParameter(valid_580137, JInt, required = false, default = nil)
  if valid_580137 != nil:
    section.add "pageSize", valid_580137
  var valid_580138 = query.getOrDefault("sortOrder")
  valid_580138 = validateParameter(valid_580138, JString, required = false, default = newJString(
      "LAST_MODIFIED_ASCENDING"))
  if valid_580138 != nil:
    section.add "sortOrder", valid_580138
  var valid_580139 = query.getOrDefault("personFields")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "personFields", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580141: Call_PeoplePeopleConnectionsList_580119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_580141.validator(path, query, header, formData, body)
  let scheme = call_580141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580141.url(scheme.get, call_580141.host, call_580141.base,
                         call_580141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580141, url, valid)

proc call*(call_580142: Call_PeoplePeopleConnectionsList_580119;
          resourceName: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; requestMaskIncludeField: string = "";
          syncToken: string = ""; requestSyncToken: bool = false; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0;
          sortOrder: string = "LAST_MODIFIED_ASCENDING"; personFields: string = "";
          prettyPrint: bool = true): Recallable =
  ## peoplePeopleConnectionsList
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token of the page to be returned.
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
  ##   requestMaskIncludeField: string
  ##                          : **Required.** Comma-separated list of person fields to be included in the
  ## response. Each path should start with `person.`: for example,
  ## `person.names` or `person.photos`.
  ##   syncToken: string
  ##            : A sync token returned by a previous call to `people.connections.list`.
  ## Only resources changed since the sync token was created will be returned.
  ## Sync requests that specify `sync_token` have an additional rate limit.
  ##   requestSyncToken: bool
  ##                   : Whether the response should include a sync token, which can be used to get
  ## all changes since the last request. For subsequent sync requests use the
  ## `sync_token` param instead. Initial sync requests that specify
  ## `request_sync_token` have an additional rate limit.
  ##   resourceName: string (required)
  ##               : The resource name to return connections for. Only `people/me` is valid.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of connections to include in the response. Valid values are
  ## between 1 and 2000, inclusive. Defaults to 100.
  ##   sortOrder: string
  ##            : The order in which the connections should be sorted. Defaults to
  ## `LAST_MODIFIED_ASCENDING`.
  ##   personFields: string
  ##               : **Required.** A field mask to restrict which fields on each person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580143 = newJObject()
  var query_580144 = newJObject()
  add(query_580144, "upload_protocol", newJString(uploadProtocol))
  add(query_580144, "fields", newJString(fields))
  add(query_580144, "pageToken", newJString(pageToken))
  add(query_580144, "quotaUser", newJString(quotaUser))
  add(query_580144, "alt", newJString(alt))
  add(query_580144, "oauth_token", newJString(oauthToken))
  add(query_580144, "callback", newJString(callback))
  add(query_580144, "access_token", newJString(accessToken))
  add(query_580144, "uploadType", newJString(uploadType))
  add(query_580144, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_580144, "syncToken", newJString(syncToken))
  add(query_580144, "requestSyncToken", newJBool(requestSyncToken))
  add(path_580143, "resourceName", newJString(resourceName))
  add(query_580144, "key", newJString(key))
  add(query_580144, "$.xgafv", newJString(Xgafv))
  add(query_580144, "pageSize", newJInt(pageSize))
  add(query_580144, "sortOrder", newJString(sortOrder))
  add(query_580144, "personFields", newJString(personFields))
  add(query_580144, "prettyPrint", newJBool(prettyPrint))
  result = call_580142.call(path_580143, query_580144, nil, nil, nil)

var peoplePeopleConnectionsList* = Call_PeoplePeopleConnectionsList_580119(
    name: "peoplePeopleConnectionsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}/connections",
    validator: validate_PeoplePeopleConnectionsList_580120, base: "/",
    url: url_PeoplePeopleConnectionsList_580121, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsMembersModify_580145 = ref object of OpenApiRestCall_579421
proc url_PeopleContactGroupsMembersModify_580147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/members:modify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsMembersModify_580146(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact group to modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580148 = path.getOrDefault("resourceName")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = nil)
  if valid_580148 != nil:
    section.add "resourceName", valid_580148
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
  var valid_580149 = query.getOrDefault("upload_protocol")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "upload_protocol", valid_580149
  var valid_580150 = query.getOrDefault("fields")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "fields", valid_580150
  var valid_580151 = query.getOrDefault("quotaUser")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "quotaUser", valid_580151
  var valid_580152 = query.getOrDefault("alt")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = newJString("json"))
  if valid_580152 != nil:
    section.add "alt", valid_580152
  var valid_580153 = query.getOrDefault("oauth_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "oauth_token", valid_580153
  var valid_580154 = query.getOrDefault("callback")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "callback", valid_580154
  var valid_580155 = query.getOrDefault("access_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "access_token", valid_580155
  var valid_580156 = query.getOrDefault("uploadType")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "uploadType", valid_580156
  var valid_580157 = query.getOrDefault("key")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "key", valid_580157
  var valid_580158 = query.getOrDefault("$.xgafv")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("1"))
  if valid_580158 != nil:
    section.add "$.xgafv", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
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

proc call*(call_580161: Call_PeopleContactGroupsMembersModify_580145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
  ## 
  let valid = call_580161.validator(path, query, header, formData, body)
  let scheme = call_580161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580161.url(scheme.get, call_580161.host, call_580161.base,
                         call_580161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580161, url, valid)

proc call*(call_580162: Call_PeopleContactGroupsMembersModify_580145;
          resourceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## peopleContactGroupsMembersModify
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
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
  ##   resourceName: string (required)
  ##               : The resource name of the contact group to modify.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580163 = newJObject()
  var query_580164 = newJObject()
  var body_580165 = newJObject()
  add(query_580164, "upload_protocol", newJString(uploadProtocol))
  add(query_580164, "fields", newJString(fields))
  add(query_580164, "quotaUser", newJString(quotaUser))
  add(query_580164, "alt", newJString(alt))
  add(query_580164, "oauth_token", newJString(oauthToken))
  add(query_580164, "callback", newJString(callback))
  add(query_580164, "access_token", newJString(accessToken))
  add(query_580164, "uploadType", newJString(uploadType))
  add(path_580163, "resourceName", newJString(resourceName))
  add(query_580164, "key", newJString(key))
  add(query_580164, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580165 = body
  add(query_580164, "prettyPrint", newJBool(prettyPrint))
  result = call_580162.call(path_580163, query_580164, nil, nil, body_580165)

var peopleContactGroupsMembersModify* = Call_PeopleContactGroupsMembersModify_580145(
    name: "peopleContactGroupsMembersModify", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/{resourceName}/members:modify",
    validator: validate_PeopleContactGroupsMembersModify_580146, base: "/",
    url: url_PeopleContactGroupsMembersModify_580147, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContact_580166 = ref object of OpenApiRestCall_579421
proc url_PeoplePeopleDeleteContact_580168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: ":deleteContact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleDeleteContact_580167(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a contact person. Any non-contact data will not be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580169 = path.getOrDefault("resourceName")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "resourceName", valid_580169
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
  var valid_580170 = query.getOrDefault("upload_protocol")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "upload_protocol", valid_580170
  var valid_580171 = query.getOrDefault("fields")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "fields", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("alt")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("json"))
  if valid_580173 != nil:
    section.add "alt", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("callback")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "callback", valid_580175
  var valid_580176 = query.getOrDefault("access_token")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "access_token", valid_580176
  var valid_580177 = query.getOrDefault("uploadType")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "uploadType", valid_580177
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("$.xgafv")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("1"))
  if valid_580179 != nil:
    section.add "$.xgafv", valid_580179
  var valid_580180 = query.getOrDefault("prettyPrint")
  valid_580180 = validateParameter(valid_580180, JBool, required = false,
                                 default = newJBool(true))
  if valid_580180 != nil:
    section.add "prettyPrint", valid_580180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580181: Call_PeoplePeopleDeleteContact_580166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact person. Any non-contact data will not be deleted.
  ## 
  let valid = call_580181.validator(path, query, header, formData, body)
  let scheme = call_580181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580181.url(scheme.get, call_580181.host, call_580181.base,
                         call_580181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580181, url, valid)

proc call*(call_580182: Call_PeoplePeopleDeleteContact_580166;
          resourceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## peoplePeopleDeleteContact
  ## Delete a contact person. Any non-contact data will not be deleted.
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
  ##   resourceName: string (required)
  ##               : The resource name of the contact to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580183 = newJObject()
  var query_580184 = newJObject()
  add(query_580184, "upload_protocol", newJString(uploadProtocol))
  add(query_580184, "fields", newJString(fields))
  add(query_580184, "quotaUser", newJString(quotaUser))
  add(query_580184, "alt", newJString(alt))
  add(query_580184, "oauth_token", newJString(oauthToken))
  add(query_580184, "callback", newJString(callback))
  add(query_580184, "access_token", newJString(accessToken))
  add(query_580184, "uploadType", newJString(uploadType))
  add(path_580183, "resourceName", newJString(resourceName))
  add(query_580184, "key", newJString(key))
  add(query_580184, "$.xgafv", newJString(Xgafv))
  add(query_580184, "prettyPrint", newJBool(prettyPrint))
  result = call_580182.call(path_580183, query_580184, nil, nil, nil)

var peoplePeopleDeleteContact* = Call_PeoplePeopleDeleteContact_580166(
    name: "peoplePeopleDeleteContact", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContact",
    validator: validate_PeoplePeopleDeleteContact_580167, base: "/",
    url: url_PeoplePeopleDeleteContact_580168, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContactPhoto_580185 = ref object of OpenApiRestCall_579421
proc url_PeoplePeopleDeleteContactPhoto_580187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: ":deleteContactPhoto")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleDeleteContactPhoto_580186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a contact's photo.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name of the contact whose photo will be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580188 = path.getOrDefault("resourceName")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "resourceName", valid_580188
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
  ##   personFields: JString
  ##               : **Optional.** Not specifying any fields will skip the post mutate read.
  ## A field mask to restrict which fields on the person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580189 = query.getOrDefault("upload_protocol")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "upload_protocol", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("quotaUser")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "quotaUser", valid_580191
  var valid_580192 = query.getOrDefault("alt")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("json"))
  if valid_580192 != nil:
    section.add "alt", valid_580192
  var valid_580193 = query.getOrDefault("oauth_token")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "oauth_token", valid_580193
  var valid_580194 = query.getOrDefault("callback")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "callback", valid_580194
  var valid_580195 = query.getOrDefault("access_token")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "access_token", valid_580195
  var valid_580196 = query.getOrDefault("uploadType")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "uploadType", valid_580196
  var valid_580197 = query.getOrDefault("key")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "key", valid_580197
  var valid_580198 = query.getOrDefault("$.xgafv")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = newJString("1"))
  if valid_580198 != nil:
    section.add "$.xgafv", valid_580198
  var valid_580199 = query.getOrDefault("personFields")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "personFields", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580201: Call_PeoplePeopleDeleteContactPhoto_580185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact's photo.
  ## 
  let valid = call_580201.validator(path, query, header, formData, body)
  let scheme = call_580201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580201.url(scheme.get, call_580201.host, call_580201.base,
                         call_580201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580201, url, valid)

proc call*(call_580202: Call_PeoplePeopleDeleteContactPhoto_580185;
          resourceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; personFields: string = "";
          prettyPrint: bool = true): Recallable =
  ## peoplePeopleDeleteContactPhoto
  ## Delete a contact's photo.
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
  ##   resourceName: string (required)
  ##               : The resource name of the contact whose photo will be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   personFields: string
  ##               : **Optional.** Not specifying any fields will skip the post mutate read.
  ## A field mask to restrict which fields on the person are
  ## returned. Multiple fields can be specified by separating them with commas.
  ## Valid values are:
  ## 
  ## * addresses
  ## * ageRanges
  ## * biographies
  ## * birthdays
  ## * braggingRights
  ## * coverPhotos
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * metadata
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * photos
  ## * relations
  ## * relationshipInterests
  ## * relationshipStatuses
  ## * residences
  ## * sipAddresses
  ## * skills
  ## * taglines
  ## * urls
  ## * userDefined
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580203 = newJObject()
  var query_580204 = newJObject()
  add(query_580204, "upload_protocol", newJString(uploadProtocol))
  add(query_580204, "fields", newJString(fields))
  add(query_580204, "quotaUser", newJString(quotaUser))
  add(query_580204, "alt", newJString(alt))
  add(query_580204, "oauth_token", newJString(oauthToken))
  add(query_580204, "callback", newJString(callback))
  add(query_580204, "access_token", newJString(accessToken))
  add(query_580204, "uploadType", newJString(uploadType))
  add(path_580203, "resourceName", newJString(resourceName))
  add(query_580204, "key", newJString(key))
  add(query_580204, "$.xgafv", newJString(Xgafv))
  add(query_580204, "personFields", newJString(personFields))
  add(query_580204, "prettyPrint", newJBool(prettyPrint))
  result = call_580202.call(path_580203, query_580204, nil, nil, nil)

var peoplePeopleDeleteContactPhoto* = Call_PeoplePeopleDeleteContactPhoto_580185(
    name: "peoplePeopleDeleteContactPhoto", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContactPhoto",
    validator: validate_PeoplePeopleDeleteContactPhoto_580186, base: "/",
    url: url_PeoplePeopleDeleteContactPhoto_580187, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContact_580205 = ref object of OpenApiRestCall_579421
proc url_PeoplePeopleUpdateContact_580207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: ":updateContact")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleUpdateContact_580206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update contact data for an existing contact person. Any non-contact data
  ## will not be modified.
  ## 
  ## The request throws a 400 error if `updatePersonFields` is not specified.
  ## <br>
  ## The request throws a 400 error if `person.metadata.sources` is not
  ## specified for the contact to be updated.
  ## <br>
  ## The request throws a 400 error with an error with reason
  ## `"failedPrecondition"` if `person.metadata.sources.etag` is different than
  ## the contact's etag, which indicates the contact has changed since its data
  ## was read. Clients should get the latest person and re-apply their updates
  ## to the latest person.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : The resource name for the person, assigned by the server. An ASCII string
  ## with a max length of 27 characters, in the form of
  ## `people/`<var>person_id</var>.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580208 = path.getOrDefault("resourceName")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "resourceName", valid_580208
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
  ##   updatePersonFields: JString
  ##                     : **Required.** A field mask to restrict which fields on the person are
  ## updated. Multiple fields can be specified by separating them with commas.
  ## All updated fields will be replaced. Valid values are:
  ## 
  ## * addresses
  ## * biographies
  ## * birthdays
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * relations
  ## * residences
  ## * sipAddresses
  ## * urls
  ## * userDefined
  section = newJObject()
  var valid_580209 = query.getOrDefault("upload_protocol")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "upload_protocol", valid_580209
  var valid_580210 = query.getOrDefault("fields")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "fields", valid_580210
  var valid_580211 = query.getOrDefault("quotaUser")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "quotaUser", valid_580211
  var valid_580212 = query.getOrDefault("alt")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("json"))
  if valid_580212 != nil:
    section.add "alt", valid_580212
  var valid_580213 = query.getOrDefault("oauth_token")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "oauth_token", valid_580213
  var valid_580214 = query.getOrDefault("callback")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "callback", valid_580214
  var valid_580215 = query.getOrDefault("access_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "access_token", valid_580215
  var valid_580216 = query.getOrDefault("uploadType")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "uploadType", valid_580216
  var valid_580217 = query.getOrDefault("key")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "key", valid_580217
  var valid_580218 = query.getOrDefault("$.xgafv")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("1"))
  if valid_580218 != nil:
    section.add "$.xgafv", valid_580218
  var valid_580219 = query.getOrDefault("prettyPrint")
  valid_580219 = validateParameter(valid_580219, JBool, required = false,
                                 default = newJBool(true))
  if valid_580219 != nil:
    section.add "prettyPrint", valid_580219
  var valid_580220 = query.getOrDefault("updatePersonFields")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "updatePersonFields", valid_580220
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

proc call*(call_580222: Call_PeoplePeopleUpdateContact_580205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update contact data for an existing contact person. Any non-contact data
  ## will not be modified.
  ## 
  ## The request throws a 400 error if `updatePersonFields` is not specified.
  ## <br>
  ## The request throws a 400 error if `person.metadata.sources` is not
  ## specified for the contact to be updated.
  ## <br>
  ## The request throws a 400 error with an error with reason
  ## `"failedPrecondition"` if `person.metadata.sources.etag` is different than
  ## the contact's etag, which indicates the contact has changed since its data
  ## was read. Clients should get the latest person and re-apply their updates
  ## to the latest person.
  ## 
  let valid = call_580222.validator(path, query, header, formData, body)
  let scheme = call_580222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580222.url(scheme.get, call_580222.host, call_580222.base,
                         call_580222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580222, url, valid)

proc call*(call_580223: Call_PeoplePeopleUpdateContact_580205;
          resourceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updatePersonFields: string = ""): Recallable =
  ## peoplePeopleUpdateContact
  ## Update contact data for an existing contact person. Any non-contact data
  ## will not be modified.
  ## 
  ## The request throws a 400 error if `updatePersonFields` is not specified.
  ## <br>
  ## The request throws a 400 error if `person.metadata.sources` is not
  ## specified for the contact to be updated.
  ## <br>
  ## The request throws a 400 error with an error with reason
  ## `"failedPrecondition"` if `person.metadata.sources.etag` is different than
  ## the contact's etag, which indicates the contact has changed since its data
  ## was read. Clients should get the latest person and re-apply their updates
  ## to the latest person.
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
  ##   resourceName: string (required)
  ##               : The resource name for the person, assigned by the server. An ASCII string
  ## with a max length of 27 characters, in the form of
  ## `people/`<var>person_id</var>.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updatePersonFields: string
  ##                     : **Required.** A field mask to restrict which fields on the person are
  ## updated. Multiple fields can be specified by separating them with commas.
  ## All updated fields will be replaced. Valid values are:
  ## 
  ## * addresses
  ## * biographies
  ## * birthdays
  ## * emailAddresses
  ## * events
  ## * genders
  ## * imClients
  ## * interests
  ## * locales
  ## * memberships
  ## * names
  ## * nicknames
  ## * occupations
  ## * organizations
  ## * phoneNumbers
  ## * relations
  ## * residences
  ## * sipAddresses
  ## * urls
  ## * userDefined
  var path_580224 = newJObject()
  var query_580225 = newJObject()
  var body_580226 = newJObject()
  add(query_580225, "upload_protocol", newJString(uploadProtocol))
  add(query_580225, "fields", newJString(fields))
  add(query_580225, "quotaUser", newJString(quotaUser))
  add(query_580225, "alt", newJString(alt))
  add(query_580225, "oauth_token", newJString(oauthToken))
  add(query_580225, "callback", newJString(callback))
  add(query_580225, "access_token", newJString(accessToken))
  add(query_580225, "uploadType", newJString(uploadType))
  add(path_580224, "resourceName", newJString(resourceName))
  add(query_580225, "key", newJString(key))
  add(query_580225, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580226 = body
  add(query_580225, "prettyPrint", newJBool(prettyPrint))
  add(query_580225, "updatePersonFields", newJString(updatePersonFields))
  result = call_580223.call(path_580224, query_580225, nil, nil, body_580226)

var peoplePeopleUpdateContact* = Call_PeoplePeopleUpdateContact_580205(
    name: "peoplePeopleUpdateContact", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContact",
    validator: validate_PeoplePeopleUpdateContact_580206, base: "/",
    url: url_PeoplePeopleUpdateContact_580207, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContactPhoto_580227 = ref object of OpenApiRestCall_579421
proc url_PeoplePeopleUpdateContactPhoto_580229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: ":updateContactPhoto")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeoplePeopleUpdateContactPhoto_580228(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a contact's photo.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : Person resource name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580230 = path.getOrDefault("resourceName")
  valid_580230 = validateParameter(valid_580230, JString, required = true,
                                 default = nil)
  if valid_580230 != nil:
    section.add "resourceName", valid_580230
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
  var valid_580231 = query.getOrDefault("upload_protocol")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "upload_protocol", valid_580231
  var valid_580232 = query.getOrDefault("fields")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "fields", valid_580232
  var valid_580233 = query.getOrDefault("quotaUser")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "quotaUser", valid_580233
  var valid_580234 = query.getOrDefault("alt")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("json"))
  if valid_580234 != nil:
    section.add "alt", valid_580234
  var valid_580235 = query.getOrDefault("oauth_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "oauth_token", valid_580235
  var valid_580236 = query.getOrDefault("callback")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "callback", valid_580236
  var valid_580237 = query.getOrDefault("access_token")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "access_token", valid_580237
  var valid_580238 = query.getOrDefault("uploadType")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "uploadType", valid_580238
  var valid_580239 = query.getOrDefault("key")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "key", valid_580239
  var valid_580240 = query.getOrDefault("$.xgafv")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("1"))
  if valid_580240 != nil:
    section.add "$.xgafv", valid_580240
  var valid_580241 = query.getOrDefault("prettyPrint")
  valid_580241 = validateParameter(valid_580241, JBool, required = false,
                                 default = newJBool(true))
  if valid_580241 != nil:
    section.add "prettyPrint", valid_580241
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

proc call*(call_580243: Call_PeoplePeopleUpdateContactPhoto_580227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a contact's photo.
  ## 
  let valid = call_580243.validator(path, query, header, formData, body)
  let scheme = call_580243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580243.url(scheme.get, call_580243.host, call_580243.base,
                         call_580243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580243, url, valid)

proc call*(call_580244: Call_PeoplePeopleUpdateContactPhoto_580227;
          resourceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## peoplePeopleUpdateContactPhoto
  ## Update a contact's photo.
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
  ##   resourceName: string (required)
  ##               : Person resource name
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580245 = newJObject()
  var query_580246 = newJObject()
  var body_580247 = newJObject()
  add(query_580246, "upload_protocol", newJString(uploadProtocol))
  add(query_580246, "fields", newJString(fields))
  add(query_580246, "quotaUser", newJString(quotaUser))
  add(query_580246, "alt", newJString(alt))
  add(query_580246, "oauth_token", newJString(oauthToken))
  add(query_580246, "callback", newJString(callback))
  add(query_580246, "access_token", newJString(accessToken))
  add(query_580246, "uploadType", newJString(uploadType))
  add(path_580245, "resourceName", newJString(resourceName))
  add(query_580246, "key", newJString(key))
  add(query_580246, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580247 = body
  add(query_580246, "prettyPrint", newJBool(prettyPrint))
  result = call_580244.call(path_580245, query_580246, nil, nil, body_580247)

var peoplePeopleUpdateContactPhoto* = Call_PeoplePeopleUpdateContactPhoto_580227(
    name: "peoplePeopleUpdateContactPhoto", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContactPhoto",
    validator: validate_PeoplePeopleUpdateContactPhoto_580228, base: "/",
    url: url_PeoplePeopleUpdateContactPhoto_580229, schemes: {Scheme.Https})
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
