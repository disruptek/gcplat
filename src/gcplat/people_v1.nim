
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "people"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PeopleContactGroupsCreate_588994 = ref object of OpenApiRestCall_588450
proc url_PeopleContactGroupsCreate_588996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsCreate_588995(path: JsonNode; query: JsonNode;
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
  var valid_588997 = query.getOrDefault("upload_protocol")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "upload_protocol", valid_588997
  var valid_588998 = query.getOrDefault("fields")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "fields", valid_588998
  var valid_588999 = query.getOrDefault("quotaUser")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "quotaUser", valid_588999
  var valid_589000 = query.getOrDefault("alt")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = newJString("json"))
  if valid_589000 != nil:
    section.add "alt", valid_589000
  var valid_589001 = query.getOrDefault("oauth_token")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "oauth_token", valid_589001
  var valid_589002 = query.getOrDefault("callback")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "callback", valid_589002
  var valid_589003 = query.getOrDefault("access_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "access_token", valid_589003
  var valid_589004 = query.getOrDefault("uploadType")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "uploadType", valid_589004
  var valid_589005 = query.getOrDefault("key")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "key", valid_589005
  var valid_589006 = query.getOrDefault("$.xgafv")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("1"))
  if valid_589006 != nil:
    section.add "$.xgafv", valid_589006
  var valid_589007 = query.getOrDefault("prettyPrint")
  valid_589007 = validateParameter(valid_589007, JBool, required = false,
                                 default = newJBool(true))
  if valid_589007 != nil:
    section.add "prettyPrint", valid_589007
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

proc call*(call_589009: Call_PeopleContactGroupsCreate_588994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact group owned by the authenticated user.
  ## 
  let valid = call_589009.validator(path, query, header, formData, body)
  let scheme = call_589009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589009.url(scheme.get, call_589009.host, call_589009.base,
                         call_589009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589009, url, valid)

proc call*(call_589010: Call_PeopleContactGroupsCreate_588994;
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
  var query_589011 = newJObject()
  var body_589012 = newJObject()
  add(query_589011, "upload_protocol", newJString(uploadProtocol))
  add(query_589011, "fields", newJString(fields))
  add(query_589011, "quotaUser", newJString(quotaUser))
  add(query_589011, "alt", newJString(alt))
  add(query_589011, "oauth_token", newJString(oauthToken))
  add(query_589011, "callback", newJString(callback))
  add(query_589011, "access_token", newJString(accessToken))
  add(query_589011, "uploadType", newJString(uploadType))
  add(query_589011, "key", newJString(key))
  add(query_589011, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589012 = body
  add(query_589011, "prettyPrint", newJBool(prettyPrint))
  result = call_589010.call(nil, query_589011, nil, nil, body_589012)

var peopleContactGroupsCreate* = Call_PeopleContactGroupsCreate_588994(
    name: "peopleContactGroupsCreate", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsCreate_588995, base: "/",
    url: url_PeopleContactGroupsCreate_588996, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsList_588719 = ref object of OpenApiRestCall_588450
proc url_PeopleContactGroupsList_588721(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsList_588720(path: JsonNode; query: JsonNode;
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
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("pageToken")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "pageToken", valid_588835
  var valid_588836 = query.getOrDefault("quotaUser")
  valid_588836 = validateParameter(valid_588836, JString, required = false,
                                 default = nil)
  if valid_588836 != nil:
    section.add "quotaUser", valid_588836
  var valid_588850 = query.getOrDefault("alt")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = newJString("json"))
  if valid_588850 != nil:
    section.add "alt", valid_588850
  var valid_588851 = query.getOrDefault("oauth_token")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "oauth_token", valid_588851
  var valid_588852 = query.getOrDefault("callback")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "callback", valid_588852
  var valid_588853 = query.getOrDefault("access_token")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "access_token", valid_588853
  var valid_588854 = query.getOrDefault("uploadType")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "uploadType", valid_588854
  var valid_588855 = query.getOrDefault("syncToken")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "syncToken", valid_588855
  var valid_588856 = query.getOrDefault("key")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "key", valid_588856
  var valid_588857 = query.getOrDefault("$.xgafv")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("1"))
  if valid_588857 != nil:
    section.add "$.xgafv", valid_588857
  var valid_588858 = query.getOrDefault("pageSize")
  valid_588858 = validateParameter(valid_588858, JInt, required = false, default = nil)
  if valid_588858 != nil:
    section.add "pageSize", valid_588858
  var valid_588859 = query.getOrDefault("prettyPrint")
  valid_588859 = validateParameter(valid_588859, JBool, required = false,
                                 default = newJBool(true))
  if valid_588859 != nil:
    section.add "prettyPrint", valid_588859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588882: Call_PeopleContactGroupsList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
  ## 
  let valid = call_588882.validator(path, query, header, formData, body)
  let scheme = call_588882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588882.url(scheme.get, call_588882.host, call_588882.base,
                         call_588882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588882, url, valid)

proc call*(call_588953: Call_PeopleContactGroupsList_588719;
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
  var query_588954 = newJObject()
  add(query_588954, "upload_protocol", newJString(uploadProtocol))
  add(query_588954, "fields", newJString(fields))
  add(query_588954, "pageToken", newJString(pageToken))
  add(query_588954, "quotaUser", newJString(quotaUser))
  add(query_588954, "alt", newJString(alt))
  add(query_588954, "oauth_token", newJString(oauthToken))
  add(query_588954, "callback", newJString(callback))
  add(query_588954, "access_token", newJString(accessToken))
  add(query_588954, "uploadType", newJString(uploadType))
  add(query_588954, "syncToken", newJString(syncToken))
  add(query_588954, "key", newJString(key))
  add(query_588954, "$.xgafv", newJString(Xgafv))
  add(query_588954, "pageSize", newJInt(pageSize))
  add(query_588954, "prettyPrint", newJBool(prettyPrint))
  result = call_588953.call(nil, query_588954, nil, nil, nil)

var peopleContactGroupsList* = Call_PeopleContactGroupsList_588719(
    name: "peopleContactGroupsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsList_588720, base: "/",
    url: url_PeopleContactGroupsList_588721, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsBatchGet_589013 = ref object of OpenApiRestCall_588450
proc url_PeopleContactGroupsBatchGet_589015(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeopleContactGroupsBatchGet_589014(path: JsonNode; query: JsonNode;
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
  var valid_589016 = query.getOrDefault("upload_protocol")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "upload_protocol", valid_589016
  var valid_589017 = query.getOrDefault("fields")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "fields", valid_589017
  var valid_589018 = query.getOrDefault("maxMembers")
  valid_589018 = validateParameter(valid_589018, JInt, required = false, default = nil)
  if valid_589018 != nil:
    section.add "maxMembers", valid_589018
  var valid_589019 = query.getOrDefault("quotaUser")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "quotaUser", valid_589019
  var valid_589020 = query.getOrDefault("alt")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("json"))
  if valid_589020 != nil:
    section.add "alt", valid_589020
  var valid_589021 = query.getOrDefault("oauth_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "oauth_token", valid_589021
  var valid_589022 = query.getOrDefault("callback")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "callback", valid_589022
  var valid_589023 = query.getOrDefault("access_token")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "access_token", valid_589023
  var valid_589024 = query.getOrDefault("uploadType")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "uploadType", valid_589024
  var valid_589025 = query.getOrDefault("key")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "key", valid_589025
  var valid_589026 = query.getOrDefault("$.xgafv")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = newJString("1"))
  if valid_589026 != nil:
    section.add "$.xgafv", valid_589026
  var valid_589027 = query.getOrDefault("prettyPrint")
  valid_589027 = validateParameter(valid_589027, JBool, required = false,
                                 default = newJBool(true))
  if valid_589027 != nil:
    section.add "prettyPrint", valid_589027
  var valid_589028 = query.getOrDefault("resourceNames")
  valid_589028 = validateParameter(valid_589028, JArray, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "resourceNames", valid_589028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589029: Call_PeopleContactGroupsBatchGet_589013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
  ## 
  let valid = call_589029.validator(path, query, header, formData, body)
  let scheme = call_589029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589029.url(scheme.get, call_589029.host, call_589029.base,
                         call_589029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589029, url, valid)

proc call*(call_589030: Call_PeopleContactGroupsBatchGet_589013;
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
  var query_589031 = newJObject()
  add(query_589031, "upload_protocol", newJString(uploadProtocol))
  add(query_589031, "fields", newJString(fields))
  add(query_589031, "maxMembers", newJInt(maxMembers))
  add(query_589031, "quotaUser", newJString(quotaUser))
  add(query_589031, "alt", newJString(alt))
  add(query_589031, "oauth_token", newJString(oauthToken))
  add(query_589031, "callback", newJString(callback))
  add(query_589031, "access_token", newJString(accessToken))
  add(query_589031, "uploadType", newJString(uploadType))
  add(query_589031, "key", newJString(key))
  add(query_589031, "$.xgafv", newJString(Xgafv))
  add(query_589031, "prettyPrint", newJBool(prettyPrint))
  if resourceNames != nil:
    query_589031.add "resourceNames", resourceNames
  result = call_589030.call(nil, query_589031, nil, nil, nil)

var peopleContactGroupsBatchGet* = Call_PeopleContactGroupsBatchGet_589013(
    name: "peopleContactGroupsBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups:batchGet",
    validator: validate_PeopleContactGroupsBatchGet_589014, base: "/",
    url: url_PeopleContactGroupsBatchGet_589015, schemes: {Scheme.Https})
type
  Call_PeoplePeopleGetBatchGet_589032 = ref object of OpenApiRestCall_588450
proc url_PeoplePeopleGetBatchGet_589034(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeoplePeopleGetBatchGet_589033(path: JsonNode; query: JsonNode;
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
  var valid_589035 = query.getOrDefault("upload_protocol")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "upload_protocol", valid_589035
  var valid_589036 = query.getOrDefault("fields")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "fields", valid_589036
  var valid_589037 = query.getOrDefault("quotaUser")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "quotaUser", valid_589037
  var valid_589038 = query.getOrDefault("alt")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("json"))
  if valid_589038 != nil:
    section.add "alt", valid_589038
  var valid_589039 = query.getOrDefault("oauth_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "oauth_token", valid_589039
  var valid_589040 = query.getOrDefault("callback")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "callback", valid_589040
  var valid_589041 = query.getOrDefault("access_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "access_token", valid_589041
  var valid_589042 = query.getOrDefault("uploadType")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "uploadType", valid_589042
  var valid_589043 = query.getOrDefault("requestMask.includeField")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "requestMask.includeField", valid_589043
  var valid_589044 = query.getOrDefault("key")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "key", valid_589044
  var valid_589045 = query.getOrDefault("$.xgafv")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = newJString("1"))
  if valid_589045 != nil:
    section.add "$.xgafv", valid_589045
  var valid_589046 = query.getOrDefault("personFields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "personFields", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
  var valid_589048 = query.getOrDefault("resourceNames")
  valid_589048 = validateParameter(valid_589048, JArray, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "resourceNames", valid_589048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589049: Call_PeoplePeopleGetBatchGet_589032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_589049.validator(path, query, header, formData, body)
  let scheme = call_589049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589049.url(scheme.get, call_589049.host, call_589049.base,
                         call_589049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589049, url, valid)

proc call*(call_589050: Call_PeoplePeopleGetBatchGet_589032;
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
  var query_589051 = newJObject()
  add(query_589051, "upload_protocol", newJString(uploadProtocol))
  add(query_589051, "fields", newJString(fields))
  add(query_589051, "quotaUser", newJString(quotaUser))
  add(query_589051, "alt", newJString(alt))
  add(query_589051, "oauth_token", newJString(oauthToken))
  add(query_589051, "callback", newJString(callback))
  add(query_589051, "access_token", newJString(accessToken))
  add(query_589051, "uploadType", newJString(uploadType))
  add(query_589051, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_589051, "key", newJString(key))
  add(query_589051, "$.xgafv", newJString(Xgafv))
  add(query_589051, "personFields", newJString(personFields))
  add(query_589051, "prettyPrint", newJBool(prettyPrint))
  if resourceNames != nil:
    query_589051.add "resourceNames", resourceNames
  result = call_589050.call(nil, query_589051, nil, nil, nil)

var peoplePeopleGetBatchGet* = Call_PeoplePeopleGetBatchGet_589032(
    name: "peoplePeopleGetBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/people:batchGet",
    validator: validate_PeoplePeopleGetBatchGet_589033, base: "/",
    url: url_PeoplePeopleGetBatchGet_589034, schemes: {Scheme.Https})
type
  Call_PeoplePeopleCreateContact_589052 = ref object of OpenApiRestCall_588450
proc url_PeoplePeopleCreateContact_589054(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PeoplePeopleCreateContact_589053(path: JsonNode; query: JsonNode;
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
  var valid_589055 = query.getOrDefault("upload_protocol")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "upload_protocol", valid_589055
  var valid_589056 = query.getOrDefault("fields")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "fields", valid_589056
  var valid_589057 = query.getOrDefault("quotaUser")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "quotaUser", valid_589057
  var valid_589058 = query.getOrDefault("alt")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("json"))
  if valid_589058 != nil:
    section.add "alt", valid_589058
  var valid_589059 = query.getOrDefault("oauth_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "oauth_token", valid_589059
  var valid_589060 = query.getOrDefault("callback")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "callback", valid_589060
  var valid_589061 = query.getOrDefault("access_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "access_token", valid_589061
  var valid_589062 = query.getOrDefault("uploadType")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "uploadType", valid_589062
  var valid_589063 = query.getOrDefault("parent")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "parent", valid_589063
  var valid_589064 = query.getOrDefault("key")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "key", valid_589064
  var valid_589065 = query.getOrDefault("$.xgafv")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("1"))
  if valid_589065 != nil:
    section.add "$.xgafv", valid_589065
  var valid_589066 = query.getOrDefault("prettyPrint")
  valid_589066 = validateParameter(valid_589066, JBool, required = false,
                                 default = newJBool(true))
  if valid_589066 != nil:
    section.add "prettyPrint", valid_589066
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

proc call*(call_589068: Call_PeoplePeopleCreateContact_589052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact and return the person resource for that contact.
  ## 
  let valid = call_589068.validator(path, query, header, formData, body)
  let scheme = call_589068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589068.url(scheme.get, call_589068.host, call_589068.base,
                         call_589068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589068, url, valid)

proc call*(call_589069: Call_PeoplePeopleCreateContact_589052;
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
  var query_589070 = newJObject()
  var body_589071 = newJObject()
  add(query_589070, "upload_protocol", newJString(uploadProtocol))
  add(query_589070, "fields", newJString(fields))
  add(query_589070, "quotaUser", newJString(quotaUser))
  add(query_589070, "alt", newJString(alt))
  add(query_589070, "oauth_token", newJString(oauthToken))
  add(query_589070, "callback", newJString(callback))
  add(query_589070, "access_token", newJString(accessToken))
  add(query_589070, "uploadType", newJString(uploadType))
  add(query_589070, "parent", newJString(parent))
  add(query_589070, "key", newJString(key))
  add(query_589070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589071 = body
  add(query_589070, "prettyPrint", newJBool(prettyPrint))
  result = call_589069.call(nil, query_589070, nil, nil, body_589071)

var peoplePeopleCreateContact* = Call_PeoplePeopleCreateContact_589052(
    name: "peoplePeopleCreateContact", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/people:createContact",
    validator: validate_PeoplePeopleCreateContact_589053, base: "/",
    url: url_PeoplePeopleCreateContact_589054, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsUpdate_589107 = ref object of OpenApiRestCall_588450
proc url_PeopleContactGroupsUpdate_589109(protocol: Scheme; host: string;
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

proc validate_PeopleContactGroupsUpdate_589108(path: JsonNode; query: JsonNode;
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
  var valid_589110 = path.getOrDefault("resourceName")
  valid_589110 = validateParameter(valid_589110, JString, required = true,
                                 default = nil)
  if valid_589110 != nil:
    section.add "resourceName", valid_589110
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
  var valid_589111 = query.getOrDefault("upload_protocol")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "upload_protocol", valid_589111
  var valid_589112 = query.getOrDefault("fields")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "fields", valid_589112
  var valid_589113 = query.getOrDefault("quotaUser")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "quotaUser", valid_589113
  var valid_589114 = query.getOrDefault("alt")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = newJString("json"))
  if valid_589114 != nil:
    section.add "alt", valid_589114
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
  var valid_589119 = query.getOrDefault("key")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "key", valid_589119
  var valid_589120 = query.getOrDefault("$.xgafv")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = newJString("1"))
  if valid_589120 != nil:
    section.add "$.xgafv", valid_589120
  var valid_589121 = query.getOrDefault("prettyPrint")
  valid_589121 = validateParameter(valid_589121, JBool, required = false,
                                 default = newJBool(true))
  if valid_589121 != nil:
    section.add "prettyPrint", valid_589121
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

proc call*(call_589123: Call_PeopleContactGroupsUpdate_589107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
  ## 
  let valid = call_589123.validator(path, query, header, formData, body)
  let scheme = call_589123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589123.url(scheme.get, call_589123.host, call_589123.base,
                         call_589123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589123, url, valid)

proc call*(call_589124: Call_PeopleContactGroupsUpdate_589107;
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
  var path_589125 = newJObject()
  var query_589126 = newJObject()
  var body_589127 = newJObject()
  add(query_589126, "upload_protocol", newJString(uploadProtocol))
  add(query_589126, "fields", newJString(fields))
  add(query_589126, "quotaUser", newJString(quotaUser))
  add(query_589126, "alt", newJString(alt))
  add(query_589126, "oauth_token", newJString(oauthToken))
  add(query_589126, "callback", newJString(callback))
  add(query_589126, "access_token", newJString(accessToken))
  add(query_589126, "uploadType", newJString(uploadType))
  add(path_589125, "resourceName", newJString(resourceName))
  add(query_589126, "key", newJString(key))
  add(query_589126, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589127 = body
  add(query_589126, "prettyPrint", newJBool(prettyPrint))
  result = call_589124.call(path_589125, query_589126, nil, nil, body_589127)

var peopleContactGroupsUpdate* = Call_PeopleContactGroupsUpdate_589107(
    name: "peopleContactGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsUpdate_589108, base: "/",
    url: url_PeopleContactGroupsUpdate_589109, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsGet_589072 = ref object of OpenApiRestCall_588450
proc url_PeopleContactGroupsGet_589074(protocol: Scheme; host: string; base: string;
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

proc validate_PeopleContactGroupsGet_589073(path: JsonNode; query: JsonNode;
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
  var valid_589089 = path.getOrDefault("resourceName")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "resourceName", valid_589089
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
  var valid_589090 = query.getOrDefault("upload_protocol")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "upload_protocol", valid_589090
  var valid_589091 = query.getOrDefault("fields")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "fields", valid_589091
  var valid_589092 = query.getOrDefault("maxMembers")
  valid_589092 = validateParameter(valid_589092, JInt, required = false, default = nil)
  if valid_589092 != nil:
    section.add "maxMembers", valid_589092
  var valid_589093 = query.getOrDefault("quotaUser")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "quotaUser", valid_589093
  var valid_589094 = query.getOrDefault("alt")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = newJString("json"))
  if valid_589094 != nil:
    section.add "alt", valid_589094
  var valid_589095 = query.getOrDefault("oauth_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "oauth_token", valid_589095
  var valid_589096 = query.getOrDefault("callback")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "callback", valid_589096
  var valid_589097 = query.getOrDefault("access_token")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "access_token", valid_589097
  var valid_589098 = query.getOrDefault("uploadType")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "uploadType", valid_589098
  var valid_589099 = query.getOrDefault("requestMask.includeField")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "requestMask.includeField", valid_589099
  var valid_589100 = query.getOrDefault("key")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "key", valid_589100
  var valid_589101 = query.getOrDefault("$.xgafv")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("1"))
  if valid_589101 != nil:
    section.add "$.xgafv", valid_589101
  var valid_589102 = query.getOrDefault("prettyPrint")
  valid_589102 = validateParameter(valid_589102, JBool, required = false,
                                 default = newJBool(true))
  if valid_589102 != nil:
    section.add "prettyPrint", valid_589102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589103: Call_PeopleContactGroupsGet_589072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ## 
  let valid = call_589103.validator(path, query, header, formData, body)
  let scheme = call_589103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589103.url(scheme.get, call_589103.host, call_589103.base,
                         call_589103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589103, url, valid)

proc call*(call_589104: Call_PeopleContactGroupsGet_589072; resourceName: string;
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
  var path_589105 = newJObject()
  var query_589106 = newJObject()
  add(query_589106, "upload_protocol", newJString(uploadProtocol))
  add(query_589106, "fields", newJString(fields))
  add(query_589106, "maxMembers", newJInt(maxMembers))
  add(query_589106, "quotaUser", newJString(quotaUser))
  add(query_589106, "alt", newJString(alt))
  add(query_589106, "oauth_token", newJString(oauthToken))
  add(query_589106, "callback", newJString(callback))
  add(query_589106, "access_token", newJString(accessToken))
  add(query_589106, "uploadType", newJString(uploadType))
  add(query_589106, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(path_589105, "resourceName", newJString(resourceName))
  add(query_589106, "key", newJString(key))
  add(query_589106, "$.xgafv", newJString(Xgafv))
  add(query_589106, "prettyPrint", newJBool(prettyPrint))
  result = call_589104.call(path_589105, query_589106, nil, nil, nil)

var peopleContactGroupsGet* = Call_PeopleContactGroupsGet_589072(
    name: "peopleContactGroupsGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsGet_589073, base: "/",
    url: url_PeopleContactGroupsGet_589074, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsDelete_589128 = ref object of OpenApiRestCall_588450
proc url_PeopleContactGroupsDelete_589130(protocol: Scheme; host: string;
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

proc validate_PeopleContactGroupsDelete_589129(path: JsonNode; query: JsonNode;
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
  var valid_589131 = path.getOrDefault("resourceName")
  valid_589131 = validateParameter(valid_589131, JString, required = true,
                                 default = nil)
  if valid_589131 != nil:
    section.add "resourceName", valid_589131
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
  var valid_589132 = query.getOrDefault("upload_protocol")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "upload_protocol", valid_589132
  var valid_589133 = query.getOrDefault("deleteContacts")
  valid_589133 = validateParameter(valid_589133, JBool, required = false, default = nil)
  if valid_589133 != nil:
    section.add "deleteContacts", valid_589133
  var valid_589134 = query.getOrDefault("fields")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "fields", valid_589134
  var valid_589135 = query.getOrDefault("quotaUser")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "quotaUser", valid_589135
  var valid_589136 = query.getOrDefault("alt")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = newJString("json"))
  if valid_589136 != nil:
    section.add "alt", valid_589136
  var valid_589137 = query.getOrDefault("oauth_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "oauth_token", valid_589137
  var valid_589138 = query.getOrDefault("callback")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "callback", valid_589138
  var valid_589139 = query.getOrDefault("access_token")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "access_token", valid_589139
  var valid_589140 = query.getOrDefault("uploadType")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "uploadType", valid_589140
  var valid_589141 = query.getOrDefault("key")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "key", valid_589141
  var valid_589142 = query.getOrDefault("$.xgafv")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = newJString("1"))
  if valid_589142 != nil:
    section.add "$.xgafv", valid_589142
  var valid_589143 = query.getOrDefault("prettyPrint")
  valid_589143 = validateParameter(valid_589143, JBool, required = false,
                                 default = newJBool(true))
  if valid_589143 != nil:
    section.add "prettyPrint", valid_589143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589144: Call_PeopleContactGroupsDelete_589128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ## 
  let valid = call_589144.validator(path, query, header, formData, body)
  let scheme = call_589144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589144.url(scheme.get, call_589144.host, call_589144.base,
                         call_589144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589144, url, valid)

proc call*(call_589145: Call_PeopleContactGroupsDelete_589128;
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
  var path_589146 = newJObject()
  var query_589147 = newJObject()
  add(query_589147, "upload_protocol", newJString(uploadProtocol))
  add(query_589147, "deleteContacts", newJBool(deleteContacts))
  add(query_589147, "fields", newJString(fields))
  add(query_589147, "quotaUser", newJString(quotaUser))
  add(query_589147, "alt", newJString(alt))
  add(query_589147, "oauth_token", newJString(oauthToken))
  add(query_589147, "callback", newJString(callback))
  add(query_589147, "access_token", newJString(accessToken))
  add(query_589147, "uploadType", newJString(uploadType))
  add(path_589146, "resourceName", newJString(resourceName))
  add(query_589147, "key", newJString(key))
  add(query_589147, "$.xgafv", newJString(Xgafv))
  add(query_589147, "prettyPrint", newJBool(prettyPrint))
  result = call_589145.call(path_589146, query_589147, nil, nil, nil)

var peopleContactGroupsDelete* = Call_PeopleContactGroupsDelete_589128(
    name: "peopleContactGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsDelete_589129, base: "/",
    url: url_PeopleContactGroupsDelete_589130, schemes: {Scheme.Https})
type
  Call_PeoplePeopleConnectionsList_589148 = ref object of OpenApiRestCall_588450
proc url_PeoplePeopleConnectionsList_589150(protocol: Scheme; host: string;
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

proc validate_PeoplePeopleConnectionsList_589149(path: JsonNode; query: JsonNode;
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
  var valid_589151 = path.getOrDefault("resourceName")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "resourceName", valid_589151
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
  var valid_589152 = query.getOrDefault("upload_protocol")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "upload_protocol", valid_589152
  var valid_589153 = query.getOrDefault("fields")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "fields", valid_589153
  var valid_589154 = query.getOrDefault("pageToken")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "pageToken", valid_589154
  var valid_589155 = query.getOrDefault("quotaUser")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "quotaUser", valid_589155
  var valid_589156 = query.getOrDefault("alt")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("json"))
  if valid_589156 != nil:
    section.add "alt", valid_589156
  var valid_589157 = query.getOrDefault("oauth_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "oauth_token", valid_589157
  var valid_589158 = query.getOrDefault("callback")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "callback", valid_589158
  var valid_589159 = query.getOrDefault("access_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "access_token", valid_589159
  var valid_589160 = query.getOrDefault("uploadType")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "uploadType", valid_589160
  var valid_589161 = query.getOrDefault("requestMask.includeField")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "requestMask.includeField", valid_589161
  var valid_589162 = query.getOrDefault("syncToken")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "syncToken", valid_589162
  var valid_589163 = query.getOrDefault("requestSyncToken")
  valid_589163 = validateParameter(valid_589163, JBool, required = false, default = nil)
  if valid_589163 != nil:
    section.add "requestSyncToken", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
  var valid_589165 = query.getOrDefault("$.xgafv")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = newJString("1"))
  if valid_589165 != nil:
    section.add "$.xgafv", valid_589165
  var valid_589166 = query.getOrDefault("pageSize")
  valid_589166 = validateParameter(valid_589166, JInt, required = false, default = nil)
  if valid_589166 != nil:
    section.add "pageSize", valid_589166
  var valid_589167 = query.getOrDefault("sortOrder")
  valid_589167 = validateParameter(valid_589167, JString, required = false, default = newJString(
      "LAST_MODIFIED_ASCENDING"))
  if valid_589167 != nil:
    section.add "sortOrder", valid_589167
  var valid_589168 = query.getOrDefault("personFields")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "personFields", valid_589168
  var valid_589169 = query.getOrDefault("prettyPrint")
  valid_589169 = validateParameter(valid_589169, JBool, required = false,
                                 default = newJBool(true))
  if valid_589169 != nil:
    section.add "prettyPrint", valid_589169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589170: Call_PeoplePeopleConnectionsList_589148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_589170.validator(path, query, header, formData, body)
  let scheme = call_589170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589170.url(scheme.get, call_589170.host, call_589170.base,
                         call_589170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589170, url, valid)

proc call*(call_589171: Call_PeoplePeopleConnectionsList_589148;
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
  var path_589172 = newJObject()
  var query_589173 = newJObject()
  add(query_589173, "upload_protocol", newJString(uploadProtocol))
  add(query_589173, "fields", newJString(fields))
  add(query_589173, "pageToken", newJString(pageToken))
  add(query_589173, "quotaUser", newJString(quotaUser))
  add(query_589173, "alt", newJString(alt))
  add(query_589173, "oauth_token", newJString(oauthToken))
  add(query_589173, "callback", newJString(callback))
  add(query_589173, "access_token", newJString(accessToken))
  add(query_589173, "uploadType", newJString(uploadType))
  add(query_589173, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_589173, "syncToken", newJString(syncToken))
  add(query_589173, "requestSyncToken", newJBool(requestSyncToken))
  add(path_589172, "resourceName", newJString(resourceName))
  add(query_589173, "key", newJString(key))
  add(query_589173, "$.xgafv", newJString(Xgafv))
  add(query_589173, "pageSize", newJInt(pageSize))
  add(query_589173, "sortOrder", newJString(sortOrder))
  add(query_589173, "personFields", newJString(personFields))
  add(query_589173, "prettyPrint", newJBool(prettyPrint))
  result = call_589171.call(path_589172, query_589173, nil, nil, nil)

var peoplePeopleConnectionsList* = Call_PeoplePeopleConnectionsList_589148(
    name: "peoplePeopleConnectionsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}/connections",
    validator: validate_PeoplePeopleConnectionsList_589149, base: "/",
    url: url_PeoplePeopleConnectionsList_589150, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsMembersModify_589174 = ref object of OpenApiRestCall_588450
proc url_PeopleContactGroupsMembersModify_589176(protocol: Scheme; host: string;
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

proc validate_PeopleContactGroupsMembersModify_589175(path: JsonNode;
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
  var valid_589177 = path.getOrDefault("resourceName")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "resourceName", valid_589177
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
  var valid_589178 = query.getOrDefault("upload_protocol")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "upload_protocol", valid_589178
  var valid_589179 = query.getOrDefault("fields")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "fields", valid_589179
  var valid_589180 = query.getOrDefault("quotaUser")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "quotaUser", valid_589180
  var valid_589181 = query.getOrDefault("alt")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = newJString("json"))
  if valid_589181 != nil:
    section.add "alt", valid_589181
  var valid_589182 = query.getOrDefault("oauth_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "oauth_token", valid_589182
  var valid_589183 = query.getOrDefault("callback")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "callback", valid_589183
  var valid_589184 = query.getOrDefault("access_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "access_token", valid_589184
  var valid_589185 = query.getOrDefault("uploadType")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "uploadType", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("$.xgafv")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = newJString("1"))
  if valid_589187 != nil:
    section.add "$.xgafv", valid_589187
  var valid_589188 = query.getOrDefault("prettyPrint")
  valid_589188 = validateParameter(valid_589188, JBool, required = false,
                                 default = newJBool(true))
  if valid_589188 != nil:
    section.add "prettyPrint", valid_589188
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

proc call*(call_589190: Call_PeopleContactGroupsMembersModify_589174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
  ## 
  let valid = call_589190.validator(path, query, header, formData, body)
  let scheme = call_589190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589190.url(scheme.get, call_589190.host, call_589190.base,
                         call_589190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589190, url, valid)

proc call*(call_589191: Call_PeopleContactGroupsMembersModify_589174;
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
  var path_589192 = newJObject()
  var query_589193 = newJObject()
  var body_589194 = newJObject()
  add(query_589193, "upload_protocol", newJString(uploadProtocol))
  add(query_589193, "fields", newJString(fields))
  add(query_589193, "quotaUser", newJString(quotaUser))
  add(query_589193, "alt", newJString(alt))
  add(query_589193, "oauth_token", newJString(oauthToken))
  add(query_589193, "callback", newJString(callback))
  add(query_589193, "access_token", newJString(accessToken))
  add(query_589193, "uploadType", newJString(uploadType))
  add(path_589192, "resourceName", newJString(resourceName))
  add(query_589193, "key", newJString(key))
  add(query_589193, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589194 = body
  add(query_589193, "prettyPrint", newJBool(prettyPrint))
  result = call_589191.call(path_589192, query_589193, nil, nil, body_589194)

var peopleContactGroupsMembersModify* = Call_PeopleContactGroupsMembersModify_589174(
    name: "peopleContactGroupsMembersModify", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/{resourceName}/members:modify",
    validator: validate_PeopleContactGroupsMembersModify_589175, base: "/",
    url: url_PeopleContactGroupsMembersModify_589176, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContact_589195 = ref object of OpenApiRestCall_588450
proc url_PeoplePeopleDeleteContact_589197(protocol: Scheme; host: string;
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

proc validate_PeoplePeopleDeleteContact_589196(path: JsonNode; query: JsonNode;
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
  var valid_589198 = path.getOrDefault("resourceName")
  valid_589198 = validateParameter(valid_589198, JString, required = true,
                                 default = nil)
  if valid_589198 != nil:
    section.add "resourceName", valid_589198
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
  var valid_589199 = query.getOrDefault("upload_protocol")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "upload_protocol", valid_589199
  var valid_589200 = query.getOrDefault("fields")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "fields", valid_589200
  var valid_589201 = query.getOrDefault("quotaUser")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "quotaUser", valid_589201
  var valid_589202 = query.getOrDefault("alt")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("json"))
  if valid_589202 != nil:
    section.add "alt", valid_589202
  var valid_589203 = query.getOrDefault("oauth_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "oauth_token", valid_589203
  var valid_589204 = query.getOrDefault("callback")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "callback", valid_589204
  var valid_589205 = query.getOrDefault("access_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "access_token", valid_589205
  var valid_589206 = query.getOrDefault("uploadType")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "uploadType", valid_589206
  var valid_589207 = query.getOrDefault("key")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "key", valid_589207
  var valid_589208 = query.getOrDefault("$.xgafv")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("1"))
  if valid_589208 != nil:
    section.add "$.xgafv", valid_589208
  var valid_589209 = query.getOrDefault("prettyPrint")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "prettyPrint", valid_589209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589210: Call_PeoplePeopleDeleteContact_589195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact person. Any non-contact data will not be deleted.
  ## 
  let valid = call_589210.validator(path, query, header, formData, body)
  let scheme = call_589210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589210.url(scheme.get, call_589210.host, call_589210.base,
                         call_589210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589210, url, valid)

proc call*(call_589211: Call_PeoplePeopleDeleteContact_589195;
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
  var path_589212 = newJObject()
  var query_589213 = newJObject()
  add(query_589213, "upload_protocol", newJString(uploadProtocol))
  add(query_589213, "fields", newJString(fields))
  add(query_589213, "quotaUser", newJString(quotaUser))
  add(query_589213, "alt", newJString(alt))
  add(query_589213, "oauth_token", newJString(oauthToken))
  add(query_589213, "callback", newJString(callback))
  add(query_589213, "access_token", newJString(accessToken))
  add(query_589213, "uploadType", newJString(uploadType))
  add(path_589212, "resourceName", newJString(resourceName))
  add(query_589213, "key", newJString(key))
  add(query_589213, "$.xgafv", newJString(Xgafv))
  add(query_589213, "prettyPrint", newJBool(prettyPrint))
  result = call_589211.call(path_589212, query_589213, nil, nil, nil)

var peoplePeopleDeleteContact* = Call_PeoplePeopleDeleteContact_589195(
    name: "peoplePeopleDeleteContact", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContact",
    validator: validate_PeoplePeopleDeleteContact_589196, base: "/",
    url: url_PeoplePeopleDeleteContact_589197, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContactPhoto_589214 = ref object of OpenApiRestCall_588450
proc url_PeoplePeopleDeleteContactPhoto_589216(protocol: Scheme; host: string;
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

proc validate_PeoplePeopleDeleteContactPhoto_589215(path: JsonNode;
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
  var valid_589217 = path.getOrDefault("resourceName")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "resourceName", valid_589217
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
  var valid_589218 = query.getOrDefault("upload_protocol")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "upload_protocol", valid_589218
  var valid_589219 = query.getOrDefault("fields")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "fields", valid_589219
  var valid_589220 = query.getOrDefault("quotaUser")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "quotaUser", valid_589220
  var valid_589221 = query.getOrDefault("alt")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = newJString("json"))
  if valid_589221 != nil:
    section.add "alt", valid_589221
  var valid_589222 = query.getOrDefault("oauth_token")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "oauth_token", valid_589222
  var valid_589223 = query.getOrDefault("callback")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "callback", valid_589223
  var valid_589224 = query.getOrDefault("access_token")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "access_token", valid_589224
  var valid_589225 = query.getOrDefault("uploadType")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "uploadType", valid_589225
  var valid_589226 = query.getOrDefault("key")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "key", valid_589226
  var valid_589227 = query.getOrDefault("$.xgafv")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = newJString("1"))
  if valid_589227 != nil:
    section.add "$.xgafv", valid_589227
  var valid_589228 = query.getOrDefault("personFields")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "personFields", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589230: Call_PeoplePeopleDeleteContactPhoto_589214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact's photo.
  ## 
  let valid = call_589230.validator(path, query, header, formData, body)
  let scheme = call_589230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589230.url(scheme.get, call_589230.host, call_589230.base,
                         call_589230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589230, url, valid)

proc call*(call_589231: Call_PeoplePeopleDeleteContactPhoto_589214;
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
  var path_589232 = newJObject()
  var query_589233 = newJObject()
  add(query_589233, "upload_protocol", newJString(uploadProtocol))
  add(query_589233, "fields", newJString(fields))
  add(query_589233, "quotaUser", newJString(quotaUser))
  add(query_589233, "alt", newJString(alt))
  add(query_589233, "oauth_token", newJString(oauthToken))
  add(query_589233, "callback", newJString(callback))
  add(query_589233, "access_token", newJString(accessToken))
  add(query_589233, "uploadType", newJString(uploadType))
  add(path_589232, "resourceName", newJString(resourceName))
  add(query_589233, "key", newJString(key))
  add(query_589233, "$.xgafv", newJString(Xgafv))
  add(query_589233, "personFields", newJString(personFields))
  add(query_589233, "prettyPrint", newJBool(prettyPrint))
  result = call_589231.call(path_589232, query_589233, nil, nil, nil)

var peoplePeopleDeleteContactPhoto* = Call_PeoplePeopleDeleteContactPhoto_589214(
    name: "peoplePeopleDeleteContactPhoto", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContactPhoto",
    validator: validate_PeoplePeopleDeleteContactPhoto_589215, base: "/",
    url: url_PeoplePeopleDeleteContactPhoto_589216, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContact_589234 = ref object of OpenApiRestCall_588450
proc url_PeoplePeopleUpdateContact_589236(protocol: Scheme; host: string;
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

proc validate_PeoplePeopleUpdateContact_589235(path: JsonNode; query: JsonNode;
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
  var valid_589237 = path.getOrDefault("resourceName")
  valid_589237 = validateParameter(valid_589237, JString, required = true,
                                 default = nil)
  if valid_589237 != nil:
    section.add "resourceName", valid_589237
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
  var valid_589238 = query.getOrDefault("upload_protocol")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "upload_protocol", valid_589238
  var valid_589239 = query.getOrDefault("fields")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "fields", valid_589239
  var valid_589240 = query.getOrDefault("quotaUser")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "quotaUser", valid_589240
  var valid_589241 = query.getOrDefault("alt")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = newJString("json"))
  if valid_589241 != nil:
    section.add "alt", valid_589241
  var valid_589242 = query.getOrDefault("oauth_token")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "oauth_token", valid_589242
  var valid_589243 = query.getOrDefault("callback")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "callback", valid_589243
  var valid_589244 = query.getOrDefault("access_token")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "access_token", valid_589244
  var valid_589245 = query.getOrDefault("uploadType")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "uploadType", valid_589245
  var valid_589246 = query.getOrDefault("key")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "key", valid_589246
  var valid_589247 = query.getOrDefault("$.xgafv")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = newJString("1"))
  if valid_589247 != nil:
    section.add "$.xgafv", valid_589247
  var valid_589248 = query.getOrDefault("prettyPrint")
  valid_589248 = validateParameter(valid_589248, JBool, required = false,
                                 default = newJBool(true))
  if valid_589248 != nil:
    section.add "prettyPrint", valid_589248
  var valid_589249 = query.getOrDefault("updatePersonFields")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "updatePersonFields", valid_589249
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

proc call*(call_589251: Call_PeoplePeopleUpdateContact_589234; path: JsonNode;
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
  let valid = call_589251.validator(path, query, header, formData, body)
  let scheme = call_589251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589251.url(scheme.get, call_589251.host, call_589251.base,
                         call_589251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589251, url, valid)

proc call*(call_589252: Call_PeoplePeopleUpdateContact_589234;
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
  var path_589253 = newJObject()
  var query_589254 = newJObject()
  var body_589255 = newJObject()
  add(query_589254, "upload_protocol", newJString(uploadProtocol))
  add(query_589254, "fields", newJString(fields))
  add(query_589254, "quotaUser", newJString(quotaUser))
  add(query_589254, "alt", newJString(alt))
  add(query_589254, "oauth_token", newJString(oauthToken))
  add(query_589254, "callback", newJString(callback))
  add(query_589254, "access_token", newJString(accessToken))
  add(query_589254, "uploadType", newJString(uploadType))
  add(path_589253, "resourceName", newJString(resourceName))
  add(query_589254, "key", newJString(key))
  add(query_589254, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589255 = body
  add(query_589254, "prettyPrint", newJBool(prettyPrint))
  add(query_589254, "updatePersonFields", newJString(updatePersonFields))
  result = call_589252.call(path_589253, query_589254, nil, nil, body_589255)

var peoplePeopleUpdateContact* = Call_PeoplePeopleUpdateContact_589234(
    name: "peoplePeopleUpdateContact", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContact",
    validator: validate_PeoplePeopleUpdateContact_589235, base: "/",
    url: url_PeoplePeopleUpdateContact_589236, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContactPhoto_589256 = ref object of OpenApiRestCall_588450
proc url_PeoplePeopleUpdateContactPhoto_589258(protocol: Scheme; host: string;
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

proc validate_PeoplePeopleUpdateContactPhoto_589257(path: JsonNode;
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
  var valid_589259 = path.getOrDefault("resourceName")
  valid_589259 = validateParameter(valid_589259, JString, required = true,
                                 default = nil)
  if valid_589259 != nil:
    section.add "resourceName", valid_589259
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
  var valid_589260 = query.getOrDefault("upload_protocol")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "upload_protocol", valid_589260
  var valid_589261 = query.getOrDefault("fields")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "fields", valid_589261
  var valid_589262 = query.getOrDefault("quotaUser")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "quotaUser", valid_589262
  var valid_589263 = query.getOrDefault("alt")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = newJString("json"))
  if valid_589263 != nil:
    section.add "alt", valid_589263
  var valid_589264 = query.getOrDefault("oauth_token")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "oauth_token", valid_589264
  var valid_589265 = query.getOrDefault("callback")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "callback", valid_589265
  var valid_589266 = query.getOrDefault("access_token")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "access_token", valid_589266
  var valid_589267 = query.getOrDefault("uploadType")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "uploadType", valid_589267
  var valid_589268 = query.getOrDefault("key")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "key", valid_589268
  var valid_589269 = query.getOrDefault("$.xgafv")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = newJString("1"))
  if valid_589269 != nil:
    section.add "$.xgafv", valid_589269
  var valid_589270 = query.getOrDefault("prettyPrint")
  valid_589270 = validateParameter(valid_589270, JBool, required = false,
                                 default = newJBool(true))
  if valid_589270 != nil:
    section.add "prettyPrint", valid_589270
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

proc call*(call_589272: Call_PeoplePeopleUpdateContactPhoto_589256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a contact's photo.
  ## 
  let valid = call_589272.validator(path, query, header, formData, body)
  let scheme = call_589272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589272.url(scheme.get, call_589272.host, call_589272.base,
                         call_589272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589272, url, valid)

proc call*(call_589273: Call_PeoplePeopleUpdateContactPhoto_589256;
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
  var path_589274 = newJObject()
  var query_589275 = newJObject()
  var body_589276 = newJObject()
  add(query_589275, "upload_protocol", newJString(uploadProtocol))
  add(query_589275, "fields", newJString(fields))
  add(query_589275, "quotaUser", newJString(quotaUser))
  add(query_589275, "alt", newJString(alt))
  add(query_589275, "oauth_token", newJString(oauthToken))
  add(query_589275, "callback", newJString(callback))
  add(query_589275, "access_token", newJString(accessToken))
  add(query_589275, "uploadType", newJString(uploadType))
  add(path_589274, "resourceName", newJString(resourceName))
  add(query_589275, "key", newJString(key))
  add(query_589275, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589276 = body
  add(query_589275, "prettyPrint", newJBool(prettyPrint))
  result = call_589273.call(path_589274, query_589275, nil, nil, body_589276)

var peoplePeopleUpdateContactPhoto* = Call_PeoplePeopleUpdateContactPhoto_589256(
    name: "peoplePeopleUpdateContactPhoto", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContactPhoto",
    validator: validate_PeoplePeopleUpdateContactPhoto_589257, base: "/",
    url: url_PeoplePeopleUpdateContactPhoto_589258, schemes: {Scheme.Https})
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
