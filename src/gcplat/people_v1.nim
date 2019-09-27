
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PeopleContactGroupsCreate_593965 = ref object of OpenApiRestCall_593421
proc url_PeopleContactGroupsCreate_593967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsCreate_593966(path: JsonNode; query: JsonNode;
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
  var valid_593968 = query.getOrDefault("upload_protocol")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "upload_protocol", valid_593968
  var valid_593969 = query.getOrDefault("fields")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "fields", valid_593969
  var valid_593970 = query.getOrDefault("quotaUser")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "quotaUser", valid_593970
  var valid_593971 = query.getOrDefault("alt")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = newJString("json"))
  if valid_593971 != nil:
    section.add "alt", valid_593971
  var valid_593972 = query.getOrDefault("oauth_token")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "oauth_token", valid_593972
  var valid_593973 = query.getOrDefault("callback")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "callback", valid_593973
  var valid_593974 = query.getOrDefault("access_token")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "access_token", valid_593974
  var valid_593975 = query.getOrDefault("uploadType")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "uploadType", valid_593975
  var valid_593976 = query.getOrDefault("key")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "key", valid_593976
  var valid_593977 = query.getOrDefault("$.xgafv")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = newJString("1"))
  if valid_593977 != nil:
    section.add "$.xgafv", valid_593977
  var valid_593978 = query.getOrDefault("prettyPrint")
  valid_593978 = validateParameter(valid_593978, JBool, required = false,
                                 default = newJBool(true))
  if valid_593978 != nil:
    section.add "prettyPrint", valid_593978
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

proc call*(call_593980: Call_PeopleContactGroupsCreate_593965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact group owned by the authenticated user.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_PeopleContactGroupsCreate_593965;
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
  var query_593982 = newJObject()
  var body_593983 = newJObject()
  add(query_593982, "upload_protocol", newJString(uploadProtocol))
  add(query_593982, "fields", newJString(fields))
  add(query_593982, "quotaUser", newJString(quotaUser))
  add(query_593982, "alt", newJString(alt))
  add(query_593982, "oauth_token", newJString(oauthToken))
  add(query_593982, "callback", newJString(callback))
  add(query_593982, "access_token", newJString(accessToken))
  add(query_593982, "uploadType", newJString(uploadType))
  add(query_593982, "key", newJString(key))
  add(query_593982, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593983 = body
  add(query_593982, "prettyPrint", newJBool(prettyPrint))
  result = call_593981.call(nil, query_593982, nil, nil, body_593983)

var peopleContactGroupsCreate* = Call_PeopleContactGroupsCreate_593965(
    name: "peopleContactGroupsCreate", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsCreate_593966, base: "/",
    url: url_PeopleContactGroupsCreate_593967, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsList_593690 = ref object of OpenApiRestCall_593421
proc url_PeopleContactGroupsList_593692(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsList_593691(path: JsonNode; query: JsonNode;
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
  var valid_593804 = query.getOrDefault("upload_protocol")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "upload_protocol", valid_593804
  var valid_593805 = query.getOrDefault("fields")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "fields", valid_593805
  var valid_593806 = query.getOrDefault("pageToken")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "pageToken", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("alt")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("json"))
  if valid_593821 != nil:
    section.add "alt", valid_593821
  var valid_593822 = query.getOrDefault("oauth_token")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "oauth_token", valid_593822
  var valid_593823 = query.getOrDefault("callback")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "callback", valid_593823
  var valid_593824 = query.getOrDefault("access_token")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "access_token", valid_593824
  var valid_593825 = query.getOrDefault("uploadType")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "uploadType", valid_593825
  var valid_593826 = query.getOrDefault("syncToken")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "syncToken", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("pageSize")
  valid_593829 = validateParameter(valid_593829, JInt, required = false, default = nil)
  if valid_593829 != nil:
    section.add "pageSize", valid_593829
  var valid_593830 = query.getOrDefault("prettyPrint")
  valid_593830 = validateParameter(valid_593830, JBool, required = false,
                                 default = newJBool(true))
  if valid_593830 != nil:
    section.add "prettyPrint", valid_593830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593853: Call_PeopleContactGroupsList_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
  ## 
  let valid = call_593853.validator(path, query, header, formData, body)
  let scheme = call_593853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593853.url(scheme.get, call_593853.host, call_593853.base,
                         call_593853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593853, url, valid)

proc call*(call_593924: Call_PeopleContactGroupsList_593690;
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
  var query_593925 = newJObject()
  add(query_593925, "upload_protocol", newJString(uploadProtocol))
  add(query_593925, "fields", newJString(fields))
  add(query_593925, "pageToken", newJString(pageToken))
  add(query_593925, "quotaUser", newJString(quotaUser))
  add(query_593925, "alt", newJString(alt))
  add(query_593925, "oauth_token", newJString(oauthToken))
  add(query_593925, "callback", newJString(callback))
  add(query_593925, "access_token", newJString(accessToken))
  add(query_593925, "uploadType", newJString(uploadType))
  add(query_593925, "syncToken", newJString(syncToken))
  add(query_593925, "key", newJString(key))
  add(query_593925, "$.xgafv", newJString(Xgafv))
  add(query_593925, "pageSize", newJInt(pageSize))
  add(query_593925, "prettyPrint", newJBool(prettyPrint))
  result = call_593924.call(nil, query_593925, nil, nil, nil)

var peopleContactGroupsList* = Call_PeopleContactGroupsList_593690(
    name: "peopleContactGroupsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsList_593691, base: "/",
    url: url_PeopleContactGroupsList_593692, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsBatchGet_593984 = ref object of OpenApiRestCall_593421
proc url_PeopleContactGroupsBatchGet_593986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsBatchGet_593985(path: JsonNode; query: JsonNode;
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
  var valid_593987 = query.getOrDefault("upload_protocol")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "upload_protocol", valid_593987
  var valid_593988 = query.getOrDefault("fields")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "fields", valid_593988
  var valid_593989 = query.getOrDefault("maxMembers")
  valid_593989 = validateParameter(valid_593989, JInt, required = false, default = nil)
  if valid_593989 != nil:
    section.add "maxMembers", valid_593989
  var valid_593990 = query.getOrDefault("quotaUser")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "quotaUser", valid_593990
  var valid_593991 = query.getOrDefault("alt")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("json"))
  if valid_593991 != nil:
    section.add "alt", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("callback")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "callback", valid_593993
  var valid_593994 = query.getOrDefault("access_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "access_token", valid_593994
  var valid_593995 = query.getOrDefault("uploadType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "uploadType", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("$.xgafv")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("1"))
  if valid_593997 != nil:
    section.add "$.xgafv", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
  var valid_593999 = query.getOrDefault("resourceNames")
  valid_593999 = validateParameter(valid_593999, JArray, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "resourceNames", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_PeopleContactGroupsBatchGet_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_PeopleContactGroupsBatchGet_593984;
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
  var query_594002 = newJObject()
  add(query_594002, "upload_protocol", newJString(uploadProtocol))
  add(query_594002, "fields", newJString(fields))
  add(query_594002, "maxMembers", newJInt(maxMembers))
  add(query_594002, "quotaUser", newJString(quotaUser))
  add(query_594002, "alt", newJString(alt))
  add(query_594002, "oauth_token", newJString(oauthToken))
  add(query_594002, "callback", newJString(callback))
  add(query_594002, "access_token", newJString(accessToken))
  add(query_594002, "uploadType", newJString(uploadType))
  add(query_594002, "key", newJString(key))
  add(query_594002, "$.xgafv", newJString(Xgafv))
  add(query_594002, "prettyPrint", newJBool(prettyPrint))
  if resourceNames != nil:
    query_594002.add "resourceNames", resourceNames
  result = call_594001.call(nil, query_594002, nil, nil, nil)

var peopleContactGroupsBatchGet* = Call_PeopleContactGroupsBatchGet_593984(
    name: "peopleContactGroupsBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups:batchGet",
    validator: validate_PeopleContactGroupsBatchGet_593985, base: "/",
    url: url_PeopleContactGroupsBatchGet_593986, schemes: {Scheme.Https})
type
  Call_PeoplePeopleGetBatchGet_594003 = ref object of OpenApiRestCall_593421
proc url_PeoplePeopleGetBatchGet_594005(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PeoplePeopleGetBatchGet_594004(path: JsonNode; query: JsonNode;
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
  var valid_594006 = query.getOrDefault("upload_protocol")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "upload_protocol", valid_594006
  var valid_594007 = query.getOrDefault("fields")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "fields", valid_594007
  var valid_594008 = query.getOrDefault("quotaUser")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "quotaUser", valid_594008
  var valid_594009 = query.getOrDefault("alt")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = newJString("json"))
  if valid_594009 != nil:
    section.add "alt", valid_594009
  var valid_594010 = query.getOrDefault("oauth_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "oauth_token", valid_594010
  var valid_594011 = query.getOrDefault("callback")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "callback", valid_594011
  var valid_594012 = query.getOrDefault("access_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "access_token", valid_594012
  var valid_594013 = query.getOrDefault("uploadType")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "uploadType", valid_594013
  var valid_594014 = query.getOrDefault("requestMask.includeField")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "requestMask.includeField", valid_594014
  var valid_594015 = query.getOrDefault("key")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "key", valid_594015
  var valid_594016 = query.getOrDefault("$.xgafv")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = newJString("1"))
  if valid_594016 != nil:
    section.add "$.xgafv", valid_594016
  var valid_594017 = query.getOrDefault("personFields")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "personFields", valid_594017
  var valid_594018 = query.getOrDefault("prettyPrint")
  valid_594018 = validateParameter(valid_594018, JBool, required = false,
                                 default = newJBool(true))
  if valid_594018 != nil:
    section.add "prettyPrint", valid_594018
  var valid_594019 = query.getOrDefault("resourceNames")
  valid_594019 = validateParameter(valid_594019, JArray, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "resourceNames", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_PeoplePeopleGetBatchGet_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_PeoplePeopleGetBatchGet_594003;
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
  var query_594022 = newJObject()
  add(query_594022, "upload_protocol", newJString(uploadProtocol))
  add(query_594022, "fields", newJString(fields))
  add(query_594022, "quotaUser", newJString(quotaUser))
  add(query_594022, "alt", newJString(alt))
  add(query_594022, "oauth_token", newJString(oauthToken))
  add(query_594022, "callback", newJString(callback))
  add(query_594022, "access_token", newJString(accessToken))
  add(query_594022, "uploadType", newJString(uploadType))
  add(query_594022, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_594022, "key", newJString(key))
  add(query_594022, "$.xgafv", newJString(Xgafv))
  add(query_594022, "personFields", newJString(personFields))
  add(query_594022, "prettyPrint", newJBool(prettyPrint))
  if resourceNames != nil:
    query_594022.add "resourceNames", resourceNames
  result = call_594021.call(nil, query_594022, nil, nil, nil)

var peoplePeopleGetBatchGet* = Call_PeoplePeopleGetBatchGet_594003(
    name: "peoplePeopleGetBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/people:batchGet",
    validator: validate_PeoplePeopleGetBatchGet_594004, base: "/",
    url: url_PeoplePeopleGetBatchGet_594005, schemes: {Scheme.Https})
type
  Call_PeoplePeopleCreateContact_594023 = ref object of OpenApiRestCall_593421
proc url_PeoplePeopleCreateContact_594025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PeoplePeopleCreateContact_594024(path: JsonNode; query: JsonNode;
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
  var valid_594026 = query.getOrDefault("upload_protocol")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "upload_protocol", valid_594026
  var valid_594027 = query.getOrDefault("fields")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "fields", valid_594027
  var valid_594028 = query.getOrDefault("quotaUser")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "quotaUser", valid_594028
  var valid_594029 = query.getOrDefault("alt")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = newJString("json"))
  if valid_594029 != nil:
    section.add "alt", valid_594029
  var valid_594030 = query.getOrDefault("oauth_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "oauth_token", valid_594030
  var valid_594031 = query.getOrDefault("callback")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "callback", valid_594031
  var valid_594032 = query.getOrDefault("access_token")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "access_token", valid_594032
  var valid_594033 = query.getOrDefault("uploadType")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "uploadType", valid_594033
  var valid_594034 = query.getOrDefault("parent")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "parent", valid_594034
  var valid_594035 = query.getOrDefault("key")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "key", valid_594035
  var valid_594036 = query.getOrDefault("$.xgafv")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("1"))
  if valid_594036 != nil:
    section.add "$.xgafv", valid_594036
  var valid_594037 = query.getOrDefault("prettyPrint")
  valid_594037 = validateParameter(valid_594037, JBool, required = false,
                                 default = newJBool(true))
  if valid_594037 != nil:
    section.add "prettyPrint", valid_594037
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

proc call*(call_594039: Call_PeoplePeopleCreateContact_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact and return the person resource for that contact.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_PeoplePeopleCreateContact_594023;
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
  var query_594041 = newJObject()
  var body_594042 = newJObject()
  add(query_594041, "upload_protocol", newJString(uploadProtocol))
  add(query_594041, "fields", newJString(fields))
  add(query_594041, "quotaUser", newJString(quotaUser))
  add(query_594041, "alt", newJString(alt))
  add(query_594041, "oauth_token", newJString(oauthToken))
  add(query_594041, "callback", newJString(callback))
  add(query_594041, "access_token", newJString(accessToken))
  add(query_594041, "uploadType", newJString(uploadType))
  add(query_594041, "parent", newJString(parent))
  add(query_594041, "key", newJString(key))
  add(query_594041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594042 = body
  add(query_594041, "prettyPrint", newJBool(prettyPrint))
  result = call_594040.call(nil, query_594041, nil, nil, body_594042)

var peoplePeopleCreateContact* = Call_PeoplePeopleCreateContact_594023(
    name: "peoplePeopleCreateContact", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/people:createContact",
    validator: validate_PeoplePeopleCreateContact_594024, base: "/",
    url: url_PeoplePeopleCreateContact_594025, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsUpdate_594078 = ref object of OpenApiRestCall_593421
proc url_PeopleContactGroupsUpdate_594080(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsUpdate_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = path.getOrDefault("resourceName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "resourceName", valid_594081
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
  var valid_594082 = query.getOrDefault("upload_protocol")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "upload_protocol", valid_594082
  var valid_594083 = query.getOrDefault("fields")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "fields", valid_594083
  var valid_594084 = query.getOrDefault("quotaUser")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "quotaUser", valid_594084
  var valid_594085 = query.getOrDefault("alt")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = newJString("json"))
  if valid_594085 != nil:
    section.add "alt", valid_594085
  var valid_594086 = query.getOrDefault("oauth_token")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "oauth_token", valid_594086
  var valid_594087 = query.getOrDefault("callback")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "callback", valid_594087
  var valid_594088 = query.getOrDefault("access_token")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "access_token", valid_594088
  var valid_594089 = query.getOrDefault("uploadType")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "uploadType", valid_594089
  var valid_594090 = query.getOrDefault("key")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "key", valid_594090
  var valid_594091 = query.getOrDefault("$.xgafv")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = newJString("1"))
  if valid_594091 != nil:
    section.add "$.xgafv", valid_594091
  var valid_594092 = query.getOrDefault("prettyPrint")
  valid_594092 = validateParameter(valid_594092, JBool, required = false,
                                 default = newJBool(true))
  if valid_594092 != nil:
    section.add "prettyPrint", valid_594092
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

proc call*(call_594094: Call_PeopleContactGroupsUpdate_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
  ## 
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_PeopleContactGroupsUpdate_594078;
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
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  var body_594098 = newJObject()
  add(query_594097, "upload_protocol", newJString(uploadProtocol))
  add(query_594097, "fields", newJString(fields))
  add(query_594097, "quotaUser", newJString(quotaUser))
  add(query_594097, "alt", newJString(alt))
  add(query_594097, "oauth_token", newJString(oauthToken))
  add(query_594097, "callback", newJString(callback))
  add(query_594097, "access_token", newJString(accessToken))
  add(query_594097, "uploadType", newJString(uploadType))
  add(path_594096, "resourceName", newJString(resourceName))
  add(query_594097, "key", newJString(key))
  add(query_594097, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594098 = body
  add(query_594097, "prettyPrint", newJBool(prettyPrint))
  result = call_594095.call(path_594096, query_594097, nil, nil, body_594098)

var peopleContactGroupsUpdate* = Call_PeopleContactGroupsUpdate_594078(
    name: "peopleContactGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsUpdate_594079, base: "/",
    url: url_PeopleContactGroupsUpdate_594080, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsGet_594043 = ref object of OpenApiRestCall_593421
proc url_PeopleContactGroupsGet_594045(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsGet_594044(path: JsonNode; query: JsonNode;
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
  var valid_594060 = path.getOrDefault("resourceName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "resourceName", valid_594060
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
  var valid_594061 = query.getOrDefault("upload_protocol")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "upload_protocol", valid_594061
  var valid_594062 = query.getOrDefault("fields")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "fields", valid_594062
  var valid_594063 = query.getOrDefault("maxMembers")
  valid_594063 = validateParameter(valid_594063, JInt, required = false, default = nil)
  if valid_594063 != nil:
    section.add "maxMembers", valid_594063
  var valid_594064 = query.getOrDefault("quotaUser")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "quotaUser", valid_594064
  var valid_594065 = query.getOrDefault("alt")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = newJString("json"))
  if valid_594065 != nil:
    section.add "alt", valid_594065
  var valid_594066 = query.getOrDefault("oauth_token")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "oauth_token", valid_594066
  var valid_594067 = query.getOrDefault("callback")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "callback", valid_594067
  var valid_594068 = query.getOrDefault("access_token")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "access_token", valid_594068
  var valid_594069 = query.getOrDefault("uploadType")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "uploadType", valid_594069
  var valid_594070 = query.getOrDefault("requestMask.includeField")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "requestMask.includeField", valid_594070
  var valid_594071 = query.getOrDefault("key")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "key", valid_594071
  var valid_594072 = query.getOrDefault("$.xgafv")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("1"))
  if valid_594072 != nil:
    section.add "$.xgafv", valid_594072
  var valid_594073 = query.getOrDefault("prettyPrint")
  valid_594073 = validateParameter(valid_594073, JBool, required = false,
                                 default = newJBool(true))
  if valid_594073 != nil:
    section.add "prettyPrint", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_PeopleContactGroupsGet_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_PeopleContactGroupsGet_594043; resourceName: string;
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
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(query_594077, "upload_protocol", newJString(uploadProtocol))
  add(query_594077, "fields", newJString(fields))
  add(query_594077, "maxMembers", newJInt(maxMembers))
  add(query_594077, "quotaUser", newJString(quotaUser))
  add(query_594077, "alt", newJString(alt))
  add(query_594077, "oauth_token", newJString(oauthToken))
  add(query_594077, "callback", newJString(callback))
  add(query_594077, "access_token", newJString(accessToken))
  add(query_594077, "uploadType", newJString(uploadType))
  add(query_594077, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(path_594076, "resourceName", newJString(resourceName))
  add(query_594077, "key", newJString(key))
  add(query_594077, "$.xgafv", newJString(Xgafv))
  add(query_594077, "prettyPrint", newJBool(prettyPrint))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var peopleContactGroupsGet* = Call_PeopleContactGroupsGet_594043(
    name: "peopleContactGroupsGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsGet_594044, base: "/",
    url: url_PeopleContactGroupsGet_594045, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsDelete_594099 = ref object of OpenApiRestCall_593421
proc url_PeopleContactGroupsDelete_594101(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PeopleContactGroupsDelete_594100(path: JsonNode; query: JsonNode;
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
  var valid_594102 = path.getOrDefault("resourceName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceName", valid_594102
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
  var valid_594103 = query.getOrDefault("upload_protocol")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "upload_protocol", valid_594103
  var valid_594104 = query.getOrDefault("deleteContacts")
  valid_594104 = validateParameter(valid_594104, JBool, required = false, default = nil)
  if valid_594104 != nil:
    section.add "deleteContacts", valid_594104
  var valid_594105 = query.getOrDefault("fields")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "fields", valid_594105
  var valid_594106 = query.getOrDefault("quotaUser")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "quotaUser", valid_594106
  var valid_594107 = query.getOrDefault("alt")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("json"))
  if valid_594107 != nil:
    section.add "alt", valid_594107
  var valid_594108 = query.getOrDefault("oauth_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "oauth_token", valid_594108
  var valid_594109 = query.getOrDefault("callback")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "callback", valid_594109
  var valid_594110 = query.getOrDefault("access_token")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "access_token", valid_594110
  var valid_594111 = query.getOrDefault("uploadType")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "uploadType", valid_594111
  var valid_594112 = query.getOrDefault("key")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "key", valid_594112
  var valid_594113 = query.getOrDefault("$.xgafv")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = newJString("1"))
  if valid_594113 != nil:
    section.add "$.xgafv", valid_594113
  var valid_594114 = query.getOrDefault("prettyPrint")
  valid_594114 = validateParameter(valid_594114, JBool, required = false,
                                 default = newJBool(true))
  if valid_594114 != nil:
    section.add "prettyPrint", valid_594114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594115: Call_PeopleContactGroupsDelete_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_PeopleContactGroupsDelete_594099;
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
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  add(query_594118, "upload_protocol", newJString(uploadProtocol))
  add(query_594118, "deleteContacts", newJBool(deleteContacts))
  add(query_594118, "fields", newJString(fields))
  add(query_594118, "quotaUser", newJString(quotaUser))
  add(query_594118, "alt", newJString(alt))
  add(query_594118, "oauth_token", newJString(oauthToken))
  add(query_594118, "callback", newJString(callback))
  add(query_594118, "access_token", newJString(accessToken))
  add(query_594118, "uploadType", newJString(uploadType))
  add(path_594117, "resourceName", newJString(resourceName))
  add(query_594118, "key", newJString(key))
  add(query_594118, "$.xgafv", newJString(Xgafv))
  add(query_594118, "prettyPrint", newJBool(prettyPrint))
  result = call_594116.call(path_594117, query_594118, nil, nil, nil)

var peopleContactGroupsDelete* = Call_PeopleContactGroupsDelete_594099(
    name: "peopleContactGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsDelete_594100, base: "/",
    url: url_PeopleContactGroupsDelete_594101, schemes: {Scheme.Https})
type
  Call_PeoplePeopleConnectionsList_594119 = ref object of OpenApiRestCall_593421
proc url_PeoplePeopleConnectionsList_594121(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PeoplePeopleConnectionsList_594120(path: JsonNode; query: JsonNode;
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
  var valid_594122 = path.getOrDefault("resourceName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "resourceName", valid_594122
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
  var valid_594123 = query.getOrDefault("upload_protocol")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "upload_protocol", valid_594123
  var valid_594124 = query.getOrDefault("fields")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "fields", valid_594124
  var valid_594125 = query.getOrDefault("pageToken")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "pageToken", valid_594125
  var valid_594126 = query.getOrDefault("quotaUser")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "quotaUser", valid_594126
  var valid_594127 = query.getOrDefault("alt")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = newJString("json"))
  if valid_594127 != nil:
    section.add "alt", valid_594127
  var valid_594128 = query.getOrDefault("oauth_token")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "oauth_token", valid_594128
  var valid_594129 = query.getOrDefault("callback")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "callback", valid_594129
  var valid_594130 = query.getOrDefault("access_token")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "access_token", valid_594130
  var valid_594131 = query.getOrDefault("uploadType")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "uploadType", valid_594131
  var valid_594132 = query.getOrDefault("requestMask.includeField")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "requestMask.includeField", valid_594132
  var valid_594133 = query.getOrDefault("syncToken")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "syncToken", valid_594133
  var valid_594134 = query.getOrDefault("requestSyncToken")
  valid_594134 = validateParameter(valid_594134, JBool, required = false, default = nil)
  if valid_594134 != nil:
    section.add "requestSyncToken", valid_594134
  var valid_594135 = query.getOrDefault("key")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "key", valid_594135
  var valid_594136 = query.getOrDefault("$.xgafv")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = newJString("1"))
  if valid_594136 != nil:
    section.add "$.xgafv", valid_594136
  var valid_594137 = query.getOrDefault("pageSize")
  valid_594137 = validateParameter(valid_594137, JInt, required = false, default = nil)
  if valid_594137 != nil:
    section.add "pageSize", valid_594137
  var valid_594138 = query.getOrDefault("sortOrder")
  valid_594138 = validateParameter(valid_594138, JString, required = false, default = newJString(
      "LAST_MODIFIED_ASCENDING"))
  if valid_594138 != nil:
    section.add "sortOrder", valid_594138
  var valid_594139 = query.getOrDefault("personFields")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "personFields", valid_594139
  var valid_594140 = query.getOrDefault("prettyPrint")
  valid_594140 = validateParameter(valid_594140, JBool, required = false,
                                 default = newJBool(true))
  if valid_594140 != nil:
    section.add "prettyPrint", valid_594140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594141: Call_PeoplePeopleConnectionsList_594119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_PeoplePeopleConnectionsList_594119;
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
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  add(query_594144, "upload_protocol", newJString(uploadProtocol))
  add(query_594144, "fields", newJString(fields))
  add(query_594144, "pageToken", newJString(pageToken))
  add(query_594144, "quotaUser", newJString(quotaUser))
  add(query_594144, "alt", newJString(alt))
  add(query_594144, "oauth_token", newJString(oauthToken))
  add(query_594144, "callback", newJString(callback))
  add(query_594144, "access_token", newJString(accessToken))
  add(query_594144, "uploadType", newJString(uploadType))
  add(query_594144, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_594144, "syncToken", newJString(syncToken))
  add(query_594144, "requestSyncToken", newJBool(requestSyncToken))
  add(path_594143, "resourceName", newJString(resourceName))
  add(query_594144, "key", newJString(key))
  add(query_594144, "$.xgafv", newJString(Xgafv))
  add(query_594144, "pageSize", newJInt(pageSize))
  add(query_594144, "sortOrder", newJString(sortOrder))
  add(query_594144, "personFields", newJString(personFields))
  add(query_594144, "prettyPrint", newJBool(prettyPrint))
  result = call_594142.call(path_594143, query_594144, nil, nil, nil)

var peoplePeopleConnectionsList* = Call_PeoplePeopleConnectionsList_594119(
    name: "peoplePeopleConnectionsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}/connections",
    validator: validate_PeoplePeopleConnectionsList_594120, base: "/",
    url: url_PeoplePeopleConnectionsList_594121, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsMembersModify_594145 = ref object of OpenApiRestCall_593421
proc url_PeopleContactGroupsMembersModify_594147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PeopleContactGroupsMembersModify_594146(path: JsonNode;
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
  var valid_594148 = path.getOrDefault("resourceName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "resourceName", valid_594148
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
  var valid_594149 = query.getOrDefault("upload_protocol")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "upload_protocol", valid_594149
  var valid_594150 = query.getOrDefault("fields")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "fields", valid_594150
  var valid_594151 = query.getOrDefault("quotaUser")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "quotaUser", valid_594151
  var valid_594152 = query.getOrDefault("alt")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = newJString("json"))
  if valid_594152 != nil:
    section.add "alt", valid_594152
  var valid_594153 = query.getOrDefault("oauth_token")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "oauth_token", valid_594153
  var valid_594154 = query.getOrDefault("callback")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "callback", valid_594154
  var valid_594155 = query.getOrDefault("access_token")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "access_token", valid_594155
  var valid_594156 = query.getOrDefault("uploadType")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "uploadType", valid_594156
  var valid_594157 = query.getOrDefault("key")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "key", valid_594157
  var valid_594158 = query.getOrDefault("$.xgafv")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = newJString("1"))
  if valid_594158 != nil:
    section.add "$.xgafv", valid_594158
  var valid_594159 = query.getOrDefault("prettyPrint")
  valid_594159 = validateParameter(valid_594159, JBool, required = false,
                                 default = newJBool(true))
  if valid_594159 != nil:
    section.add "prettyPrint", valid_594159
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

proc call*(call_594161: Call_PeopleContactGroupsMembersModify_594145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_PeopleContactGroupsMembersModify_594145;
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
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  var body_594165 = newJObject()
  add(query_594164, "upload_protocol", newJString(uploadProtocol))
  add(query_594164, "fields", newJString(fields))
  add(query_594164, "quotaUser", newJString(quotaUser))
  add(query_594164, "alt", newJString(alt))
  add(query_594164, "oauth_token", newJString(oauthToken))
  add(query_594164, "callback", newJString(callback))
  add(query_594164, "access_token", newJString(accessToken))
  add(query_594164, "uploadType", newJString(uploadType))
  add(path_594163, "resourceName", newJString(resourceName))
  add(query_594164, "key", newJString(key))
  add(query_594164, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594165 = body
  add(query_594164, "prettyPrint", newJBool(prettyPrint))
  result = call_594162.call(path_594163, query_594164, nil, nil, body_594165)

var peopleContactGroupsMembersModify* = Call_PeopleContactGroupsMembersModify_594145(
    name: "peopleContactGroupsMembersModify", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/{resourceName}/members:modify",
    validator: validate_PeopleContactGroupsMembersModify_594146, base: "/",
    url: url_PeopleContactGroupsMembersModify_594147, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContact_594166 = ref object of OpenApiRestCall_593421
proc url_PeoplePeopleDeleteContact_594168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PeoplePeopleDeleteContact_594167(path: JsonNode; query: JsonNode;
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
  var valid_594169 = path.getOrDefault("resourceName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "resourceName", valid_594169
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
  var valid_594170 = query.getOrDefault("upload_protocol")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "upload_protocol", valid_594170
  var valid_594171 = query.getOrDefault("fields")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "fields", valid_594171
  var valid_594172 = query.getOrDefault("quotaUser")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "quotaUser", valid_594172
  var valid_594173 = query.getOrDefault("alt")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = newJString("json"))
  if valid_594173 != nil:
    section.add "alt", valid_594173
  var valid_594174 = query.getOrDefault("oauth_token")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "oauth_token", valid_594174
  var valid_594175 = query.getOrDefault("callback")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "callback", valid_594175
  var valid_594176 = query.getOrDefault("access_token")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "access_token", valid_594176
  var valid_594177 = query.getOrDefault("uploadType")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "uploadType", valid_594177
  var valid_594178 = query.getOrDefault("key")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "key", valid_594178
  var valid_594179 = query.getOrDefault("$.xgafv")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = newJString("1"))
  if valid_594179 != nil:
    section.add "$.xgafv", valid_594179
  var valid_594180 = query.getOrDefault("prettyPrint")
  valid_594180 = validateParameter(valid_594180, JBool, required = false,
                                 default = newJBool(true))
  if valid_594180 != nil:
    section.add "prettyPrint", valid_594180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594181: Call_PeoplePeopleDeleteContact_594166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact person. Any non-contact data will not be deleted.
  ## 
  let valid = call_594181.validator(path, query, header, formData, body)
  let scheme = call_594181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594181.url(scheme.get, call_594181.host, call_594181.base,
                         call_594181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594181, url, valid)

proc call*(call_594182: Call_PeoplePeopleDeleteContact_594166;
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
  var path_594183 = newJObject()
  var query_594184 = newJObject()
  add(query_594184, "upload_protocol", newJString(uploadProtocol))
  add(query_594184, "fields", newJString(fields))
  add(query_594184, "quotaUser", newJString(quotaUser))
  add(query_594184, "alt", newJString(alt))
  add(query_594184, "oauth_token", newJString(oauthToken))
  add(query_594184, "callback", newJString(callback))
  add(query_594184, "access_token", newJString(accessToken))
  add(query_594184, "uploadType", newJString(uploadType))
  add(path_594183, "resourceName", newJString(resourceName))
  add(query_594184, "key", newJString(key))
  add(query_594184, "$.xgafv", newJString(Xgafv))
  add(query_594184, "prettyPrint", newJBool(prettyPrint))
  result = call_594182.call(path_594183, query_594184, nil, nil, nil)

var peoplePeopleDeleteContact* = Call_PeoplePeopleDeleteContact_594166(
    name: "peoplePeopleDeleteContact", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContact",
    validator: validate_PeoplePeopleDeleteContact_594167, base: "/",
    url: url_PeoplePeopleDeleteContact_594168, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContactPhoto_594185 = ref object of OpenApiRestCall_593421
proc url_PeoplePeopleDeleteContactPhoto_594187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PeoplePeopleDeleteContactPhoto_594186(path: JsonNode;
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
  var valid_594188 = path.getOrDefault("resourceName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "resourceName", valid_594188
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
  var valid_594189 = query.getOrDefault("upload_protocol")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "upload_protocol", valid_594189
  var valid_594190 = query.getOrDefault("fields")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "fields", valid_594190
  var valid_594191 = query.getOrDefault("quotaUser")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "quotaUser", valid_594191
  var valid_594192 = query.getOrDefault("alt")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = newJString("json"))
  if valid_594192 != nil:
    section.add "alt", valid_594192
  var valid_594193 = query.getOrDefault("oauth_token")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "oauth_token", valid_594193
  var valid_594194 = query.getOrDefault("callback")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "callback", valid_594194
  var valid_594195 = query.getOrDefault("access_token")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "access_token", valid_594195
  var valid_594196 = query.getOrDefault("uploadType")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "uploadType", valid_594196
  var valid_594197 = query.getOrDefault("key")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "key", valid_594197
  var valid_594198 = query.getOrDefault("$.xgafv")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = newJString("1"))
  if valid_594198 != nil:
    section.add "$.xgafv", valid_594198
  var valid_594199 = query.getOrDefault("personFields")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "personFields", valid_594199
  var valid_594200 = query.getOrDefault("prettyPrint")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(true))
  if valid_594200 != nil:
    section.add "prettyPrint", valid_594200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594201: Call_PeoplePeopleDeleteContactPhoto_594185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact's photo.
  ## 
  let valid = call_594201.validator(path, query, header, formData, body)
  let scheme = call_594201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594201.url(scheme.get, call_594201.host, call_594201.base,
                         call_594201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594201, url, valid)

proc call*(call_594202: Call_PeoplePeopleDeleteContactPhoto_594185;
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
  var path_594203 = newJObject()
  var query_594204 = newJObject()
  add(query_594204, "upload_protocol", newJString(uploadProtocol))
  add(query_594204, "fields", newJString(fields))
  add(query_594204, "quotaUser", newJString(quotaUser))
  add(query_594204, "alt", newJString(alt))
  add(query_594204, "oauth_token", newJString(oauthToken))
  add(query_594204, "callback", newJString(callback))
  add(query_594204, "access_token", newJString(accessToken))
  add(query_594204, "uploadType", newJString(uploadType))
  add(path_594203, "resourceName", newJString(resourceName))
  add(query_594204, "key", newJString(key))
  add(query_594204, "$.xgafv", newJString(Xgafv))
  add(query_594204, "personFields", newJString(personFields))
  add(query_594204, "prettyPrint", newJBool(prettyPrint))
  result = call_594202.call(path_594203, query_594204, nil, nil, nil)

var peoplePeopleDeleteContactPhoto* = Call_PeoplePeopleDeleteContactPhoto_594185(
    name: "peoplePeopleDeleteContactPhoto", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContactPhoto",
    validator: validate_PeoplePeopleDeleteContactPhoto_594186, base: "/",
    url: url_PeoplePeopleDeleteContactPhoto_594187, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContact_594205 = ref object of OpenApiRestCall_593421
proc url_PeoplePeopleUpdateContact_594207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PeoplePeopleUpdateContact_594206(path: JsonNode; query: JsonNode;
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
  var valid_594208 = path.getOrDefault("resourceName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "resourceName", valid_594208
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
  var valid_594209 = query.getOrDefault("upload_protocol")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "upload_protocol", valid_594209
  var valid_594210 = query.getOrDefault("fields")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "fields", valid_594210
  var valid_594211 = query.getOrDefault("quotaUser")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "quotaUser", valid_594211
  var valid_594212 = query.getOrDefault("alt")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = newJString("json"))
  if valid_594212 != nil:
    section.add "alt", valid_594212
  var valid_594213 = query.getOrDefault("oauth_token")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "oauth_token", valid_594213
  var valid_594214 = query.getOrDefault("callback")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "callback", valid_594214
  var valid_594215 = query.getOrDefault("access_token")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "access_token", valid_594215
  var valid_594216 = query.getOrDefault("uploadType")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "uploadType", valid_594216
  var valid_594217 = query.getOrDefault("key")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "key", valid_594217
  var valid_594218 = query.getOrDefault("$.xgafv")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = newJString("1"))
  if valid_594218 != nil:
    section.add "$.xgafv", valid_594218
  var valid_594219 = query.getOrDefault("prettyPrint")
  valid_594219 = validateParameter(valid_594219, JBool, required = false,
                                 default = newJBool(true))
  if valid_594219 != nil:
    section.add "prettyPrint", valid_594219
  var valid_594220 = query.getOrDefault("updatePersonFields")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "updatePersonFields", valid_594220
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

proc call*(call_594222: Call_PeoplePeopleUpdateContact_594205; path: JsonNode;
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
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_PeoplePeopleUpdateContact_594205;
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
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  var body_594226 = newJObject()
  add(query_594225, "upload_protocol", newJString(uploadProtocol))
  add(query_594225, "fields", newJString(fields))
  add(query_594225, "quotaUser", newJString(quotaUser))
  add(query_594225, "alt", newJString(alt))
  add(query_594225, "oauth_token", newJString(oauthToken))
  add(query_594225, "callback", newJString(callback))
  add(query_594225, "access_token", newJString(accessToken))
  add(query_594225, "uploadType", newJString(uploadType))
  add(path_594224, "resourceName", newJString(resourceName))
  add(query_594225, "key", newJString(key))
  add(query_594225, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594226 = body
  add(query_594225, "prettyPrint", newJBool(prettyPrint))
  add(query_594225, "updatePersonFields", newJString(updatePersonFields))
  result = call_594223.call(path_594224, query_594225, nil, nil, body_594226)

var peoplePeopleUpdateContact* = Call_PeoplePeopleUpdateContact_594205(
    name: "peoplePeopleUpdateContact", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContact",
    validator: validate_PeoplePeopleUpdateContact_594206, base: "/",
    url: url_PeoplePeopleUpdateContact_594207, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContactPhoto_594227 = ref object of OpenApiRestCall_593421
proc url_PeoplePeopleUpdateContactPhoto_594229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PeoplePeopleUpdateContactPhoto_594228(path: JsonNode;
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
  var valid_594230 = path.getOrDefault("resourceName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "resourceName", valid_594230
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
  var valid_594231 = query.getOrDefault("upload_protocol")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "upload_protocol", valid_594231
  var valid_594232 = query.getOrDefault("fields")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "fields", valid_594232
  var valid_594233 = query.getOrDefault("quotaUser")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "quotaUser", valid_594233
  var valid_594234 = query.getOrDefault("alt")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = newJString("json"))
  if valid_594234 != nil:
    section.add "alt", valid_594234
  var valid_594235 = query.getOrDefault("oauth_token")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "oauth_token", valid_594235
  var valid_594236 = query.getOrDefault("callback")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "callback", valid_594236
  var valid_594237 = query.getOrDefault("access_token")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "access_token", valid_594237
  var valid_594238 = query.getOrDefault("uploadType")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "uploadType", valid_594238
  var valid_594239 = query.getOrDefault("key")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "key", valid_594239
  var valid_594240 = query.getOrDefault("$.xgafv")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = newJString("1"))
  if valid_594240 != nil:
    section.add "$.xgafv", valid_594240
  var valid_594241 = query.getOrDefault("prettyPrint")
  valid_594241 = validateParameter(valid_594241, JBool, required = false,
                                 default = newJBool(true))
  if valid_594241 != nil:
    section.add "prettyPrint", valid_594241
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

proc call*(call_594243: Call_PeoplePeopleUpdateContactPhoto_594227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a contact's photo.
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_PeoplePeopleUpdateContactPhoto_594227;
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
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  var body_594247 = newJObject()
  add(query_594246, "upload_protocol", newJString(uploadProtocol))
  add(query_594246, "fields", newJString(fields))
  add(query_594246, "quotaUser", newJString(quotaUser))
  add(query_594246, "alt", newJString(alt))
  add(query_594246, "oauth_token", newJString(oauthToken))
  add(query_594246, "callback", newJString(callback))
  add(query_594246, "access_token", newJString(accessToken))
  add(query_594246, "uploadType", newJString(uploadType))
  add(path_594245, "resourceName", newJString(resourceName))
  add(query_594246, "key", newJString(key))
  add(query_594246, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594247 = body
  add(query_594246, "prettyPrint", newJBool(prettyPrint))
  result = call_594244.call(path_594245, query_594246, nil, nil, body_594247)

var peoplePeopleUpdateContactPhoto* = Call_PeoplePeopleUpdateContactPhoto_594227(
    name: "peoplePeopleUpdateContactPhoto", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContactPhoto",
    validator: validate_PeoplePeopleUpdateContactPhoto_594228, base: "/",
    url: url_PeoplePeopleUpdateContactPhoto_594229, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
