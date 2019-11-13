
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "people"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PeopleContactGroupsCreate_579919 = ref object of OpenApiRestCall_579373
proc url_PeopleContactGroupsCreate_579921(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_PeopleContactGroupsCreate_579920(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new contact group owned by the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579922 = query.getOrDefault("key")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "key", valid_579922
  var valid_579923 = query.getOrDefault("prettyPrint")
  valid_579923 = validateParameter(valid_579923, JBool, required = false,
                                 default = newJBool(true))
  if valid_579923 != nil:
    section.add "prettyPrint", valid_579923
  var valid_579924 = query.getOrDefault("oauth_token")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "oauth_token", valid_579924
  var valid_579925 = query.getOrDefault("$.xgafv")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = newJString("1"))
  if valid_579925 != nil:
    section.add "$.xgafv", valid_579925
  var valid_579926 = query.getOrDefault("alt")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = newJString("json"))
  if valid_579926 != nil:
    section.add "alt", valid_579926
  var valid_579927 = query.getOrDefault("uploadType")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "uploadType", valid_579927
  var valid_579928 = query.getOrDefault("quotaUser")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "quotaUser", valid_579928
  var valid_579929 = query.getOrDefault("callback")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "callback", valid_579929
  var valid_579930 = query.getOrDefault("fields")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "fields", valid_579930
  var valid_579931 = query.getOrDefault("access_token")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "access_token", valid_579931
  var valid_579932 = query.getOrDefault("upload_protocol")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "upload_protocol", valid_579932
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

proc call*(call_579934: Call_PeopleContactGroupsCreate_579919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact group owned by the authenticated user.
  ## 
  let valid = call_579934.validator(path, query, header, formData, body)
  let scheme = call_579934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579934.url(scheme.get, call_579934.host, call_579934.base,
                         call_579934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579934, url, valid)

proc call*(call_579935: Call_PeopleContactGroupsCreate_579919; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## peopleContactGroupsCreate
  ## Create a new contact group owned by the authenticated user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579936 = newJObject()
  var body_579937 = newJObject()
  add(query_579936, "key", newJString(key))
  add(query_579936, "prettyPrint", newJBool(prettyPrint))
  add(query_579936, "oauth_token", newJString(oauthToken))
  add(query_579936, "$.xgafv", newJString(Xgafv))
  add(query_579936, "alt", newJString(alt))
  add(query_579936, "uploadType", newJString(uploadType))
  add(query_579936, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579937 = body
  add(query_579936, "callback", newJString(callback))
  add(query_579936, "fields", newJString(fields))
  add(query_579936, "access_token", newJString(accessToken))
  add(query_579936, "upload_protocol", newJString(uploadProtocol))
  result = call_579935.call(nil, query_579936, nil, nil, body_579937)

var peopleContactGroupsCreate* = Call_PeopleContactGroupsCreate_579919(
    name: "peopleContactGroupsCreate", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsCreate_579920, base: "/",
    url: url_PeopleContactGroupsCreate_579921, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsList_579644 = ref object of OpenApiRestCall_579373
proc url_PeopleContactGroupsList_579646(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_PeopleContactGroupsList_579645(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of resources to return. Valid values are between 1 and
  ## 1000, inclusive. Defaults to 30 if not set or set to 0.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous call to
  ## [ListContactGroups](/people/api/rest/v1/contactgroups/list).
  ## Requests the next page of resources.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   syncToken: JString
  ##            : A sync token, returned by a previous call to `contactgroups.list`.
  ## Only resources changed since the sync token was created will be returned.
  section = newJObject()
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("$.xgafv")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = newJString("1"))
  if valid_579774 != nil:
    section.add "$.xgafv", valid_579774
  var valid_579775 = query.getOrDefault("pageSize")
  valid_579775 = validateParameter(valid_579775, JInt, required = false, default = nil)
  if valid_579775 != nil:
    section.add "pageSize", valid_579775
  var valid_579776 = query.getOrDefault("alt")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = newJString("json"))
  if valid_579776 != nil:
    section.add "alt", valid_579776
  var valid_579777 = query.getOrDefault("uploadType")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "uploadType", valid_579777
  var valid_579778 = query.getOrDefault("quotaUser")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "quotaUser", valid_579778
  var valid_579779 = query.getOrDefault("pageToken")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "pageToken", valid_579779
  var valid_579780 = query.getOrDefault("callback")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "callback", valid_579780
  var valid_579781 = query.getOrDefault("fields")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "fields", valid_579781
  var valid_579782 = query.getOrDefault("access_token")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "access_token", valid_579782
  var valid_579783 = query.getOrDefault("upload_protocol")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "upload_protocol", valid_579783
  var valid_579784 = query.getOrDefault("syncToken")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "syncToken", valid_579784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579807: Call_PeopleContactGroupsList_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
  ## 
  let valid = call_579807.validator(path, query, header, formData, body)
  let scheme = call_579807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579807.url(scheme.get, call_579807.host, call_579807.base,
                         call_579807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579807, url, valid)

proc call*(call_579878: Call_PeopleContactGroupsList_579644; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          syncToken: string = ""): Recallable =
  ## peopleContactGroupsList
  ## List all contact groups owned by the authenticated user. Members of the
  ## contact groups are not populated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of resources to return. Valid values are between 1 and
  ## 1000, inclusive. Defaults to 30 if not set or set to 0.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous call to
  ## [ListContactGroups](/people/api/rest/v1/contactgroups/list).
  ## Requests the next page of resources.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   syncToken: string
  ##            : A sync token, returned by a previous call to `contactgroups.list`.
  ## Only resources changed since the sync token was created will be returned.
  var query_579879 = newJObject()
  add(query_579879, "key", newJString(key))
  add(query_579879, "prettyPrint", newJBool(prettyPrint))
  add(query_579879, "oauth_token", newJString(oauthToken))
  add(query_579879, "$.xgafv", newJString(Xgafv))
  add(query_579879, "pageSize", newJInt(pageSize))
  add(query_579879, "alt", newJString(alt))
  add(query_579879, "uploadType", newJString(uploadType))
  add(query_579879, "quotaUser", newJString(quotaUser))
  add(query_579879, "pageToken", newJString(pageToken))
  add(query_579879, "callback", newJString(callback))
  add(query_579879, "fields", newJString(fields))
  add(query_579879, "access_token", newJString(accessToken))
  add(query_579879, "upload_protocol", newJString(uploadProtocol))
  add(query_579879, "syncToken", newJString(syncToken))
  result = call_579878.call(nil, query_579879, nil, nil, nil)

var peopleContactGroupsList* = Call_PeopleContactGroupsList_579644(
    name: "peopleContactGroupsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups",
    validator: validate_PeopleContactGroupsList_579645, base: "/",
    url: url_PeopleContactGroupsList_579646, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsBatchGet_579938 = ref object of OpenApiRestCall_579373
proc url_PeopleContactGroupsBatchGet_579940(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_PeopleContactGroupsBatchGet_579939(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resourceNames: JArray
  ##                : Required. The resource names of the contact groups to get.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMembers: JInt
  ##             : Optional. Specifies the maximum number of members to return for each group. Defaults
  ## to 0 if not set, which will return zero members.
  section = newJObject()
  var valid_579941 = query.getOrDefault("key")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "key", valid_579941
  var valid_579942 = query.getOrDefault("prettyPrint")
  valid_579942 = validateParameter(valid_579942, JBool, required = false,
                                 default = newJBool(true))
  if valid_579942 != nil:
    section.add "prettyPrint", valid_579942
  var valid_579943 = query.getOrDefault("oauth_token")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "oauth_token", valid_579943
  var valid_579944 = query.getOrDefault("$.xgafv")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = newJString("1"))
  if valid_579944 != nil:
    section.add "$.xgafv", valid_579944
  var valid_579945 = query.getOrDefault("alt")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = newJString("json"))
  if valid_579945 != nil:
    section.add "alt", valid_579945
  var valid_579946 = query.getOrDefault("uploadType")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "uploadType", valid_579946
  var valid_579947 = query.getOrDefault("quotaUser")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "quotaUser", valid_579947
  var valid_579948 = query.getOrDefault("resourceNames")
  valid_579948 = validateParameter(valid_579948, JArray, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "resourceNames", valid_579948
  var valid_579949 = query.getOrDefault("callback")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "callback", valid_579949
  var valid_579950 = query.getOrDefault("fields")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "fields", valid_579950
  var valid_579951 = query.getOrDefault("access_token")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "access_token", valid_579951
  var valid_579952 = query.getOrDefault("upload_protocol")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "upload_protocol", valid_579952
  var valid_579953 = query.getOrDefault("maxMembers")
  valid_579953 = validateParameter(valid_579953, JInt, required = false, default = nil)
  if valid_579953 != nil:
    section.add "maxMembers", valid_579953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579954: Call_PeopleContactGroupsBatchGet_579938; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
  ## 
  let valid = call_579954.validator(path, query, header, formData, body)
  let scheme = call_579954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579954.url(scheme.get, call_579954.host, call_579954.base,
                         call_579954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579954, url, valid)

proc call*(call_579955: Call_PeopleContactGroupsBatchGet_579938; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          resourceNames: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; maxMembers: int = 0): Recallable =
  ## peopleContactGroupsBatchGet
  ## Get a list of contact groups owned by the authenticated user by specifying
  ## a list of contact group resource names.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resourceNames: JArray
  ##                : Required. The resource names of the contact groups to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMembers: int
  ##             : Optional. Specifies the maximum number of members to return for each group. Defaults
  ## to 0 if not set, which will return zero members.
  var query_579956 = newJObject()
  add(query_579956, "key", newJString(key))
  add(query_579956, "prettyPrint", newJBool(prettyPrint))
  add(query_579956, "oauth_token", newJString(oauthToken))
  add(query_579956, "$.xgafv", newJString(Xgafv))
  add(query_579956, "alt", newJString(alt))
  add(query_579956, "uploadType", newJString(uploadType))
  add(query_579956, "quotaUser", newJString(quotaUser))
  if resourceNames != nil:
    query_579956.add "resourceNames", resourceNames
  add(query_579956, "callback", newJString(callback))
  add(query_579956, "fields", newJString(fields))
  add(query_579956, "access_token", newJString(accessToken))
  add(query_579956, "upload_protocol", newJString(uploadProtocol))
  add(query_579956, "maxMembers", newJInt(maxMembers))
  result = call_579955.call(nil, query_579956, nil, nil, nil)

var peopleContactGroupsBatchGet* = Call_PeopleContactGroupsBatchGet_579938(
    name: "peopleContactGroupsBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/contactGroups:batchGet",
    validator: validate_PeopleContactGroupsBatchGet_579939, base: "/",
    url: url_PeopleContactGroupsBatchGet_579940, schemes: {Scheme.Https})
type
  Call_PeoplePeopleGetBatchGet_579957 = ref object of OpenApiRestCall_579373
proc url_PeoplePeopleGetBatchGet_579959(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_PeoplePeopleGetBatchGet_579958(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resourceNames: JArray
  ##                : Required. The resource names of the people to provide information about.
  ## 
  ## - To get information about the authenticated user, specify `people/me`.
  ## - To get information about a google account, specify
  ##   `people/`<var>account_id</var>.
  ## - To get information about a contact, specify the resource name that
  ##   identifies the contact as returned by
  ## [`people.connections.list`](/people/api/rest/v1/people.connections/list).
  ## 
  ## You can include up to 50 resource names in one request.
  ##   callback: JString
  ##           : JSONP
  ##   requestMask.includeField: JString
  ##                           : Required. Comma-separated list of person fields to be included in the response. Each
  ## path should start with `person.`: for example, `person.names` or
  ## `person.photos`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   personFields: JString
  ##               : Required. A field mask to restrict which fields on each person are returned. Multiple
  ## fields can be specified by separating them with commas. Valid values are:
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
  section = newJObject()
  var valid_579960 = query.getOrDefault("key")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "key", valid_579960
  var valid_579961 = query.getOrDefault("prettyPrint")
  valid_579961 = validateParameter(valid_579961, JBool, required = false,
                                 default = newJBool(true))
  if valid_579961 != nil:
    section.add "prettyPrint", valid_579961
  var valid_579962 = query.getOrDefault("oauth_token")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "oauth_token", valid_579962
  var valid_579963 = query.getOrDefault("$.xgafv")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("1"))
  if valid_579963 != nil:
    section.add "$.xgafv", valid_579963
  var valid_579964 = query.getOrDefault("alt")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("json"))
  if valid_579964 != nil:
    section.add "alt", valid_579964
  var valid_579965 = query.getOrDefault("uploadType")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "uploadType", valid_579965
  var valid_579966 = query.getOrDefault("quotaUser")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "quotaUser", valid_579966
  var valid_579967 = query.getOrDefault("resourceNames")
  valid_579967 = validateParameter(valid_579967, JArray, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "resourceNames", valid_579967
  var valid_579968 = query.getOrDefault("callback")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "callback", valid_579968
  var valid_579969 = query.getOrDefault("requestMask.includeField")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "requestMask.includeField", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("access_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "access_token", valid_579971
  var valid_579972 = query.getOrDefault("upload_protocol")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "upload_protocol", valid_579972
  var valid_579973 = query.getOrDefault("personFields")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "personFields", valid_579973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579974: Call_PeoplePeopleGetBatchGet_579957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_579974.validator(path, query, header, formData, body)
  let scheme = call_579974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579974.url(scheme.get, call_579974.host, call_579974.base,
                         call_579974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579974, url, valid)

proc call*(call_579975: Call_PeoplePeopleGetBatchGet_579957; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          resourceNames: JsonNode = nil; callback: string = "";
          requestMaskIncludeField: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          personFields: string = ""): Recallable =
  ## peoplePeopleGetBatchGet
  ## Provides information about a list of specific people by specifying a list
  ## of requested resource names. Use `people/me` to indicate the authenticated
  ## user.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resourceNames: JArray
  ##                : Required. The resource names of the people to provide information about.
  ## 
  ## - To get information about the authenticated user, specify `people/me`.
  ## - To get information about a google account, specify
  ##   `people/`<var>account_id</var>.
  ## - To get information about a contact, specify the resource name that
  ##   identifies the contact as returned by
  ## [`people.connections.list`](/people/api/rest/v1/people.connections/list).
  ## 
  ## You can include up to 50 resource names in one request.
  ##   callback: string
  ##           : JSONP
  ##   requestMaskIncludeField: string
  ##                          : Required. Comma-separated list of person fields to be included in the response. Each
  ## path should start with `person.`: for example, `person.names` or
  ## `person.photos`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   personFields: string
  ##               : Required. A field mask to restrict which fields on each person are returned. Multiple
  ## fields can be specified by separating them with commas. Valid values are:
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
  var query_579976 = newJObject()
  add(query_579976, "key", newJString(key))
  add(query_579976, "prettyPrint", newJBool(prettyPrint))
  add(query_579976, "oauth_token", newJString(oauthToken))
  add(query_579976, "$.xgafv", newJString(Xgafv))
  add(query_579976, "alt", newJString(alt))
  add(query_579976, "uploadType", newJString(uploadType))
  add(query_579976, "quotaUser", newJString(quotaUser))
  if resourceNames != nil:
    query_579976.add "resourceNames", resourceNames
  add(query_579976, "callback", newJString(callback))
  add(query_579976, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_579976, "fields", newJString(fields))
  add(query_579976, "access_token", newJString(accessToken))
  add(query_579976, "upload_protocol", newJString(uploadProtocol))
  add(query_579976, "personFields", newJString(personFields))
  result = call_579975.call(nil, query_579976, nil, nil, nil)

var peoplePeopleGetBatchGet* = Call_PeoplePeopleGetBatchGet_579957(
    name: "peoplePeopleGetBatchGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/people:batchGet",
    validator: validate_PeoplePeopleGetBatchGet_579958, base: "/",
    url: url_PeoplePeopleGetBatchGet_579959, schemes: {Scheme.Https})
type
  Call_PeoplePeopleCreateContact_579977 = ref object of OpenApiRestCall_579373
proc url_PeoplePeopleCreateContact_579979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_PeoplePeopleCreateContact_579978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new contact and return the person resource for that contact.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579980 = query.getOrDefault("key")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "key", valid_579980
  var valid_579981 = query.getOrDefault("prettyPrint")
  valid_579981 = validateParameter(valid_579981, JBool, required = false,
                                 default = newJBool(true))
  if valid_579981 != nil:
    section.add "prettyPrint", valid_579981
  var valid_579982 = query.getOrDefault("oauth_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "oauth_token", valid_579982
  var valid_579983 = query.getOrDefault("$.xgafv")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("1"))
  if valid_579983 != nil:
    section.add "$.xgafv", valid_579983
  var valid_579984 = query.getOrDefault("alt")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("json"))
  if valid_579984 != nil:
    section.add "alt", valid_579984
  var valid_579985 = query.getOrDefault("uploadType")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "uploadType", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("fields")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "fields", valid_579988
  var valid_579989 = query.getOrDefault("access_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "access_token", valid_579989
  var valid_579990 = query.getOrDefault("upload_protocol")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "upload_protocol", valid_579990
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

proc call*(call_579992: Call_PeoplePeopleCreateContact_579977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new contact and return the person resource for that contact.
  ## 
  let valid = call_579992.validator(path, query, header, formData, body)
  let scheme = call_579992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579992.url(scheme.get, call_579992.host, call_579992.base,
                         call_579992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579992, url, valid)

proc call*(call_579993: Call_PeoplePeopleCreateContact_579977; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## peoplePeopleCreateContact
  ## Create a new contact and return the person resource for that contact.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579994 = newJObject()
  var body_579995 = newJObject()
  add(query_579994, "key", newJString(key))
  add(query_579994, "prettyPrint", newJBool(prettyPrint))
  add(query_579994, "oauth_token", newJString(oauthToken))
  add(query_579994, "$.xgafv", newJString(Xgafv))
  add(query_579994, "alt", newJString(alt))
  add(query_579994, "uploadType", newJString(uploadType))
  add(query_579994, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579995 = body
  add(query_579994, "callback", newJString(callback))
  add(query_579994, "fields", newJString(fields))
  add(query_579994, "access_token", newJString(accessToken))
  add(query_579994, "upload_protocol", newJString(uploadProtocol))
  result = call_579993.call(nil, query_579994, nil, nil, body_579995)

var peoplePeopleCreateContact* = Call_PeoplePeopleCreateContact_579977(
    name: "peoplePeopleCreateContact", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/people:createContact",
    validator: validate_PeoplePeopleCreateContact_579978, base: "/",
    url: url_PeoplePeopleCreateContact_579979, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsUpdate_580031 = ref object of OpenApiRestCall_579373
proc url_PeopleContactGroupsUpdate_580033(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PeopleContactGroupsUpdate_580032(path: JsonNode; query: JsonNode;
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
  var valid_580034 = path.getOrDefault("resourceName")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "resourceName", valid_580034
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
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
  var valid_580037 = query.getOrDefault("oauth_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "oauth_token", valid_580037
  var valid_580038 = query.getOrDefault("$.xgafv")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("1"))
  if valid_580038 != nil:
    section.add "$.xgafv", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("uploadType")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "uploadType", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("callback")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "callback", valid_580042
  var valid_580043 = query.getOrDefault("fields")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "fields", valid_580043
  var valid_580044 = query.getOrDefault("access_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "access_token", valid_580044
  var valid_580045 = query.getOrDefault("upload_protocol")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "upload_protocol", valid_580045
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

proc call*(call_580047: Call_PeopleContactGroupsUpdate_580031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
  ## 
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_PeopleContactGroupsUpdate_580031;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## peopleContactGroupsUpdate
  ## Update the name of an existing contact group owned by the authenticated
  ## user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : The resource name for the contact group, assigned by the server. An ASCII
  ## string, in the form of `contactGroups/`<var>contact_group_id</var>.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580049 = newJObject()
  var query_580050 = newJObject()
  var body_580051 = newJObject()
  add(query_580050, "key", newJString(key))
  add(query_580050, "prettyPrint", newJBool(prettyPrint))
  add(query_580050, "oauth_token", newJString(oauthToken))
  add(query_580050, "$.xgafv", newJString(Xgafv))
  add(query_580050, "alt", newJString(alt))
  add(query_580050, "uploadType", newJString(uploadType))
  add(query_580050, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580051 = body
  add(query_580050, "callback", newJString(callback))
  add(path_580049, "resourceName", newJString(resourceName))
  add(query_580050, "fields", newJString(fields))
  add(query_580050, "access_token", newJString(accessToken))
  add(query_580050, "upload_protocol", newJString(uploadProtocol))
  result = call_580048.call(path_580049, query_580050, nil, nil, body_580051)

var peopleContactGroupsUpdate* = Call_PeopleContactGroupsUpdate_580031(
    name: "peopleContactGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsUpdate_580032, base: "/",
    url: url_PeopleContactGroupsUpdate_580033, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsGet_579996 = ref object of OpenApiRestCall_579373
proc url_PeopleContactGroupsGet_579998(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PeopleContactGroupsGet_579997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : Required. The resource name of the contact group to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580013 = path.getOrDefault("resourceName")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "resourceName", valid_580013
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   requestMask.includeField: JString
  ##                           : Required. Comma-separated list of person fields to be included in the response. Each
  ## path should start with `person.`: for example, `person.names` or
  ## `person.photos`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMembers: JInt
  ##             : Optional. Specifies the maximum number of members to return. Defaults to 0 if not
  ## set, which will return zero members.
  section = newJObject()
  var valid_580014 = query.getOrDefault("key")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "key", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("$.xgafv")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("1"))
  if valid_580017 != nil:
    section.add "$.xgafv", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("uploadType")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "uploadType", valid_580019
  var valid_580020 = query.getOrDefault("quotaUser")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "quotaUser", valid_580020
  var valid_580021 = query.getOrDefault("callback")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "callback", valid_580021
  var valid_580022 = query.getOrDefault("requestMask.includeField")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "requestMask.includeField", valid_580022
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  var valid_580024 = query.getOrDefault("access_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "access_token", valid_580024
  var valid_580025 = query.getOrDefault("upload_protocol")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "upload_protocol", valid_580025
  var valid_580026 = query.getOrDefault("maxMembers")
  valid_580026 = validateParameter(valid_580026, JInt, required = false, default = nil)
  if valid_580026 != nil:
    section.add "maxMembers", valid_580026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580027: Call_PeopleContactGroupsGet_579996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ## 
  let valid = call_580027.validator(path, query, header, formData, body)
  let scheme = call_580027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580027.url(scheme.get, call_580027.host, call_580027.base,
                         call_580027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580027, url, valid)

proc call*(call_580028: Call_PeopleContactGroupsGet_579996; resourceName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = "";
          requestMaskIncludeField: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; maxMembers: int = 0): Recallable =
  ## peopleContactGroupsGet
  ## Get a specific contact group owned by the authenticated user by specifying
  ## a contact group resource name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : Required. The resource name of the contact group to get.
  ##   requestMaskIncludeField: string
  ##                          : Required. Comma-separated list of person fields to be included in the response. Each
  ## path should start with `person.`: for example, `person.names` or
  ## `person.photos`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMembers: int
  ##             : Optional. Specifies the maximum number of members to return. Defaults to 0 if not
  ## set, which will return zero members.
  var path_580029 = newJObject()
  var query_580030 = newJObject()
  add(query_580030, "key", newJString(key))
  add(query_580030, "prettyPrint", newJBool(prettyPrint))
  add(query_580030, "oauth_token", newJString(oauthToken))
  add(query_580030, "$.xgafv", newJString(Xgafv))
  add(query_580030, "alt", newJString(alt))
  add(query_580030, "uploadType", newJString(uploadType))
  add(query_580030, "quotaUser", newJString(quotaUser))
  add(query_580030, "callback", newJString(callback))
  add(path_580029, "resourceName", newJString(resourceName))
  add(query_580030, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_580030, "fields", newJString(fields))
  add(query_580030, "access_token", newJString(accessToken))
  add(query_580030, "upload_protocol", newJString(uploadProtocol))
  add(query_580030, "maxMembers", newJInt(maxMembers))
  result = call_580028.call(path_580029, query_580030, nil, nil, nil)

var peopleContactGroupsGet* = Call_PeopleContactGroupsGet_579996(
    name: "peopleContactGroupsGet", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsGet_579997, base: "/",
    url: url_PeopleContactGroupsGet_579998, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsDelete_580052 = ref object of OpenApiRestCall_579373
proc url_PeopleContactGroupsDelete_580054(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PeopleContactGroupsDelete_580053(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : Required. The resource name of the contact group to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580055 = path.getOrDefault("resourceName")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "resourceName", valid_580055
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   deleteContacts: JBool
  ##                 : Optional. Set to true to also delete the contacts in the specified group.
  section = newJObject()
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("prettyPrint")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "prettyPrint", valid_580057
  var valid_580058 = query.getOrDefault("oauth_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "oauth_token", valid_580058
  var valid_580059 = query.getOrDefault("$.xgafv")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("1"))
  if valid_580059 != nil:
    section.add "$.xgafv", valid_580059
  var valid_580060 = query.getOrDefault("alt")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("json"))
  if valid_580060 != nil:
    section.add "alt", valid_580060
  var valid_580061 = query.getOrDefault("uploadType")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "uploadType", valid_580061
  var valid_580062 = query.getOrDefault("quotaUser")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "quotaUser", valid_580062
  var valid_580063 = query.getOrDefault("callback")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "callback", valid_580063
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("access_token")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "access_token", valid_580065
  var valid_580066 = query.getOrDefault("upload_protocol")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "upload_protocol", valid_580066
  var valid_580067 = query.getOrDefault("deleteContacts")
  valid_580067 = validateParameter(valid_580067, JBool, required = false, default = nil)
  if valid_580067 != nil:
    section.add "deleteContacts", valid_580067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580068: Call_PeopleContactGroupsDelete_580052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ## 
  let valid = call_580068.validator(path, query, header, formData, body)
  let scheme = call_580068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580068.url(scheme.get, call_580068.host, call_580068.base,
                         call_580068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580068, url, valid)

proc call*(call_580069: Call_PeopleContactGroupsDelete_580052;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          deleteContacts: bool = false): Recallable =
  ## peopleContactGroupsDelete
  ## Delete an existing contact group owned by the authenticated user by
  ## specifying a contact group resource name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : Required. The resource name of the contact group to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   deleteContacts: bool
  ##                 : Optional. Set to true to also delete the contacts in the specified group.
  var path_580070 = newJObject()
  var query_580071 = newJObject()
  add(query_580071, "key", newJString(key))
  add(query_580071, "prettyPrint", newJBool(prettyPrint))
  add(query_580071, "oauth_token", newJString(oauthToken))
  add(query_580071, "$.xgafv", newJString(Xgafv))
  add(query_580071, "alt", newJString(alt))
  add(query_580071, "uploadType", newJString(uploadType))
  add(query_580071, "quotaUser", newJString(quotaUser))
  add(query_580071, "callback", newJString(callback))
  add(path_580070, "resourceName", newJString(resourceName))
  add(query_580071, "fields", newJString(fields))
  add(query_580071, "access_token", newJString(accessToken))
  add(query_580071, "upload_protocol", newJString(uploadProtocol))
  add(query_580071, "deleteContacts", newJBool(deleteContacts))
  result = call_580069.call(path_580070, query_580071, nil, nil, nil)

var peopleContactGroupsDelete* = Call_PeopleContactGroupsDelete_580052(
    name: "peopleContactGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}",
    validator: validate_PeopleContactGroupsDelete_580053, base: "/",
    url: url_PeopleContactGroupsDelete_580054, schemes: {Scheme.Https})
type
  Call_PeoplePeopleConnectionsList_580072 = ref object of OpenApiRestCall_579373
proc url_PeoplePeopleConnectionsList_580074(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PeoplePeopleConnectionsList_580073(path: JsonNode; query: JsonNode;
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
  ##               : Required. The resource name to return connections for. Only `people/me` is valid.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580075 = path.getOrDefault("resourceName")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "resourceName", valid_580075
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The number of connections to include in the response. Valid values are
  ## between 1 and 2000, inclusive. Defaults to 100 if not set or set to 0.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token of the page to be returned.
  ##   sortOrder: JString
  ##            : The order in which the connections should be sorted. Defaults to
  ## `LAST_MODIFIED_ASCENDING`.
  ##   requestSyncToken: JBool
  ##                   : Whether the response should include a sync token, which can be used to get
  ## all changes since the last request. For subsequent sync requests use the
  ## `sync_token` param instead. Initial sync requests that specify
  ## `request_sync_token` have an additional rate limit.
  ##   callback: JString
  ##           : JSONP
  ##   requestMask.includeField: JString
  ##                           : Required. Comma-separated list of person fields to be included in the response. Each
  ## path should start with `person.`: for example, `person.names` or
  ## `person.photos`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   syncToken: JString
  ##            : A sync token returned by a previous call to `people.connections.list`.
  ## Only resources changed since the sync token was created will be returned.
  ## Sync requests that specify `sync_token` have an additional rate limit.
  ##   personFields: JString
  ##               : Required. A field mask to restrict which fields on each person are returned. Multiple
  ## fields can be specified by separating them with commas. Valid values are:
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
  section = newJObject()
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("$.xgafv")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("1"))
  if valid_580079 != nil:
    section.add "$.xgafv", valid_580079
  var valid_580080 = query.getOrDefault("pageSize")
  valid_580080 = validateParameter(valid_580080, JInt, required = false, default = nil)
  if valid_580080 != nil:
    section.add "pageSize", valid_580080
  var valid_580081 = query.getOrDefault("alt")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("json"))
  if valid_580081 != nil:
    section.add "alt", valid_580081
  var valid_580082 = query.getOrDefault("uploadType")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "uploadType", valid_580082
  var valid_580083 = query.getOrDefault("quotaUser")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "quotaUser", valid_580083
  var valid_580084 = query.getOrDefault("pageToken")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "pageToken", valid_580084
  var valid_580085 = query.getOrDefault("sortOrder")
  valid_580085 = validateParameter(valid_580085, JString, required = false, default = newJString(
      "LAST_MODIFIED_ASCENDING"))
  if valid_580085 != nil:
    section.add "sortOrder", valid_580085
  var valid_580086 = query.getOrDefault("requestSyncToken")
  valid_580086 = validateParameter(valid_580086, JBool, required = false, default = nil)
  if valid_580086 != nil:
    section.add "requestSyncToken", valid_580086
  var valid_580087 = query.getOrDefault("callback")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "callback", valid_580087
  var valid_580088 = query.getOrDefault("requestMask.includeField")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "requestMask.includeField", valid_580088
  var valid_580089 = query.getOrDefault("fields")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "fields", valid_580089
  var valid_580090 = query.getOrDefault("access_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "access_token", valid_580090
  var valid_580091 = query.getOrDefault("upload_protocol")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "upload_protocol", valid_580091
  var valid_580092 = query.getOrDefault("syncToken")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "syncToken", valid_580092
  var valid_580093 = query.getOrDefault("personFields")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "personFields", valid_580093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580094: Call_PeoplePeopleConnectionsList_580072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ## 
  let valid = call_580094.validator(path, query, header, formData, body)
  let scheme = call_580094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580094.url(scheme.get, call_580094.host, call_580094.base,
                         call_580094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580094, url, valid)

proc call*(call_580095: Call_PeoplePeopleConnectionsList_580072;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; sortOrder: string = "LAST_MODIFIED_ASCENDING";
          requestSyncToken: bool = false; callback: string = "";
          requestMaskIncludeField: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; syncToken: string = "";
          personFields: string = ""): Recallable =
  ## peoplePeopleConnectionsList
  ## Provides a list of the authenticated user's contacts merged with any
  ## connected profiles.
  ## <br>
  ## The request throws a 400 error if 'personFields' is not specified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The number of connections to include in the response. Valid values are
  ## between 1 and 2000, inclusive. Defaults to 100 if not set or set to 0.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The token of the page to be returned.
  ##   sortOrder: string
  ##            : The order in which the connections should be sorted. Defaults to
  ## `LAST_MODIFIED_ASCENDING`.
  ##   requestSyncToken: bool
  ##                   : Whether the response should include a sync token, which can be used to get
  ## all changes since the last request. For subsequent sync requests use the
  ## `sync_token` param instead. Initial sync requests that specify
  ## `request_sync_token` have an additional rate limit.
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : Required. The resource name to return connections for. Only `people/me` is valid.
  ##   requestMaskIncludeField: string
  ##                          : Required. Comma-separated list of person fields to be included in the response. Each
  ## path should start with `person.`: for example, `person.names` or
  ## `person.photos`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   syncToken: string
  ##            : A sync token returned by a previous call to `people.connections.list`.
  ## Only resources changed since the sync token was created will be returned.
  ## Sync requests that specify `sync_token` have an additional rate limit.
  ##   personFields: string
  ##               : Required. A field mask to restrict which fields on each person are returned. Multiple
  ## fields can be specified by separating them with commas. Valid values are:
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
  var path_580096 = newJObject()
  var query_580097 = newJObject()
  add(query_580097, "key", newJString(key))
  add(query_580097, "prettyPrint", newJBool(prettyPrint))
  add(query_580097, "oauth_token", newJString(oauthToken))
  add(query_580097, "$.xgafv", newJString(Xgafv))
  add(query_580097, "pageSize", newJInt(pageSize))
  add(query_580097, "alt", newJString(alt))
  add(query_580097, "uploadType", newJString(uploadType))
  add(query_580097, "quotaUser", newJString(quotaUser))
  add(query_580097, "pageToken", newJString(pageToken))
  add(query_580097, "sortOrder", newJString(sortOrder))
  add(query_580097, "requestSyncToken", newJBool(requestSyncToken))
  add(query_580097, "callback", newJString(callback))
  add(path_580096, "resourceName", newJString(resourceName))
  add(query_580097, "requestMask.includeField",
      newJString(requestMaskIncludeField))
  add(query_580097, "fields", newJString(fields))
  add(query_580097, "access_token", newJString(accessToken))
  add(query_580097, "upload_protocol", newJString(uploadProtocol))
  add(query_580097, "syncToken", newJString(syncToken))
  add(query_580097, "personFields", newJString(personFields))
  result = call_580095.call(path_580096, query_580097, nil, nil, nil)

var peoplePeopleConnectionsList* = Call_PeoplePeopleConnectionsList_580072(
    name: "peoplePeopleConnectionsList", meth: HttpMethod.HttpGet,
    host: "people.googleapis.com", route: "/v1/{resourceName}/connections",
    validator: validate_PeoplePeopleConnectionsList_580073, base: "/",
    url: url_PeoplePeopleConnectionsList_580074, schemes: {Scheme.Https})
type
  Call_PeopleContactGroupsMembersModify_580098 = ref object of OpenApiRestCall_579373
proc url_PeopleContactGroupsMembersModify_580100(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PeopleContactGroupsMembersModify_580099(path: JsonNode;
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
  ##               : Required. The resource name of the contact group to modify.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580101 = path.getOrDefault("resourceName")
  valid_580101 = validateParameter(valid_580101, JString, required = true,
                                 default = nil)
  if valid_580101 != nil:
    section.add "resourceName", valid_580101
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580102 = query.getOrDefault("key")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "key", valid_580102
  var valid_580103 = query.getOrDefault("prettyPrint")
  valid_580103 = validateParameter(valid_580103, JBool, required = false,
                                 default = newJBool(true))
  if valid_580103 != nil:
    section.add "prettyPrint", valid_580103
  var valid_580104 = query.getOrDefault("oauth_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "oauth_token", valid_580104
  var valid_580105 = query.getOrDefault("$.xgafv")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("1"))
  if valid_580105 != nil:
    section.add "$.xgafv", valid_580105
  var valid_580106 = query.getOrDefault("alt")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("json"))
  if valid_580106 != nil:
    section.add "alt", valid_580106
  var valid_580107 = query.getOrDefault("uploadType")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "uploadType", valid_580107
  var valid_580108 = query.getOrDefault("quotaUser")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "quotaUser", valid_580108
  var valid_580109 = query.getOrDefault("callback")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "callback", valid_580109
  var valid_580110 = query.getOrDefault("fields")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "fields", valid_580110
  var valid_580111 = query.getOrDefault("access_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "access_token", valid_580111
  var valid_580112 = query.getOrDefault("upload_protocol")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "upload_protocol", valid_580112
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

proc call*(call_580114: Call_PeopleContactGroupsMembersModify_580098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
  ## 
  let valid = call_580114.validator(path, query, header, formData, body)
  let scheme = call_580114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580114.url(scheme.get, call_580114.host, call_580114.base,
                         call_580114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580114, url, valid)

proc call*(call_580115: Call_PeopleContactGroupsMembersModify_580098;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## peopleContactGroupsMembersModify
  ## Modify the members of a contact group owned by the authenticated user.
  ## <br>
  ## The only system contact groups that can have members added are
  ## `contactGroups/myContacts` and `contactGroups/starred`. Other system
  ## contact groups are deprecated and can only have contacts removed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : Required. The resource name of the contact group to modify.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580116 = newJObject()
  var query_580117 = newJObject()
  var body_580118 = newJObject()
  add(query_580117, "key", newJString(key))
  add(query_580117, "prettyPrint", newJBool(prettyPrint))
  add(query_580117, "oauth_token", newJString(oauthToken))
  add(query_580117, "$.xgafv", newJString(Xgafv))
  add(query_580117, "alt", newJString(alt))
  add(query_580117, "uploadType", newJString(uploadType))
  add(query_580117, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580118 = body
  add(query_580117, "callback", newJString(callback))
  add(path_580116, "resourceName", newJString(resourceName))
  add(query_580117, "fields", newJString(fields))
  add(query_580117, "access_token", newJString(accessToken))
  add(query_580117, "upload_protocol", newJString(uploadProtocol))
  result = call_580115.call(path_580116, query_580117, nil, nil, body_580118)

var peopleContactGroupsMembersModify* = Call_PeopleContactGroupsMembersModify_580098(
    name: "peopleContactGroupsMembersModify", meth: HttpMethod.HttpPost,
    host: "people.googleapis.com", route: "/v1/{resourceName}/members:modify",
    validator: validate_PeopleContactGroupsMembersModify_580099, base: "/",
    url: url_PeopleContactGroupsMembersModify_580100, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContact_580119 = ref object of OpenApiRestCall_579373
proc url_PeoplePeopleDeleteContact_580121(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PeoplePeopleDeleteContact_580120(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a contact person. Any non-contact data will not be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : Required. The resource name of the contact to delete.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580123 = query.getOrDefault("key")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "key", valid_580123
  var valid_580124 = query.getOrDefault("prettyPrint")
  valid_580124 = validateParameter(valid_580124, JBool, required = false,
                                 default = newJBool(true))
  if valid_580124 != nil:
    section.add "prettyPrint", valid_580124
  var valid_580125 = query.getOrDefault("oauth_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "oauth_token", valid_580125
  var valid_580126 = query.getOrDefault("$.xgafv")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("1"))
  if valid_580126 != nil:
    section.add "$.xgafv", valid_580126
  var valid_580127 = query.getOrDefault("alt")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("json"))
  if valid_580127 != nil:
    section.add "alt", valid_580127
  var valid_580128 = query.getOrDefault("uploadType")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "uploadType", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("callback")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "callback", valid_580130
  var valid_580131 = query.getOrDefault("fields")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fields", valid_580131
  var valid_580132 = query.getOrDefault("access_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "access_token", valid_580132
  var valid_580133 = query.getOrDefault("upload_protocol")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "upload_protocol", valid_580133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580134: Call_PeoplePeopleDeleteContact_580119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact person. Any non-contact data will not be deleted.
  ## 
  let valid = call_580134.validator(path, query, header, formData, body)
  let scheme = call_580134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580134.url(scheme.get, call_580134.host, call_580134.base,
                         call_580134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580134, url, valid)

proc call*(call_580135: Call_PeoplePeopleDeleteContact_580119;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## peoplePeopleDeleteContact
  ## Delete a contact person. Any non-contact data will not be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : Required. The resource name of the contact to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580136 = newJObject()
  var query_580137 = newJObject()
  add(query_580137, "key", newJString(key))
  add(query_580137, "prettyPrint", newJBool(prettyPrint))
  add(query_580137, "oauth_token", newJString(oauthToken))
  add(query_580137, "$.xgafv", newJString(Xgafv))
  add(query_580137, "alt", newJString(alt))
  add(query_580137, "uploadType", newJString(uploadType))
  add(query_580137, "quotaUser", newJString(quotaUser))
  add(query_580137, "callback", newJString(callback))
  add(path_580136, "resourceName", newJString(resourceName))
  add(query_580137, "fields", newJString(fields))
  add(query_580137, "access_token", newJString(accessToken))
  add(query_580137, "upload_protocol", newJString(uploadProtocol))
  result = call_580135.call(path_580136, query_580137, nil, nil, nil)

var peoplePeopleDeleteContact* = Call_PeoplePeopleDeleteContact_580119(
    name: "peoplePeopleDeleteContact", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContact",
    validator: validate_PeoplePeopleDeleteContact_580120, base: "/",
    url: url_PeoplePeopleDeleteContact_580121, schemes: {Scheme.Https})
type
  Call_PeoplePeopleDeleteContactPhoto_580138 = ref object of OpenApiRestCall_579373
proc url_PeoplePeopleDeleteContactPhoto_580140(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PeoplePeopleDeleteContactPhoto_580139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a contact's photo.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : Required. The resource name of the contact whose photo will be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580141 = path.getOrDefault("resourceName")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "resourceName", valid_580141
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   personFields: JString
  ##               : Optional. A field mask to restrict which fields on the person are returned. Multiple
  ## fields can be specified by separating them with commas. Defaults to empty
  ## if not set, which will skip the post mutate get. Valid values are:
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
  section = newJObject()
  var valid_580142 = query.getOrDefault("key")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "key", valid_580142
  var valid_580143 = query.getOrDefault("prettyPrint")
  valid_580143 = validateParameter(valid_580143, JBool, required = false,
                                 default = newJBool(true))
  if valid_580143 != nil:
    section.add "prettyPrint", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("$.xgafv")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = newJString("1"))
  if valid_580145 != nil:
    section.add "$.xgafv", valid_580145
  var valid_580146 = query.getOrDefault("alt")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("json"))
  if valid_580146 != nil:
    section.add "alt", valid_580146
  var valid_580147 = query.getOrDefault("uploadType")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "uploadType", valid_580147
  var valid_580148 = query.getOrDefault("quotaUser")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "quotaUser", valid_580148
  var valid_580149 = query.getOrDefault("callback")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "callback", valid_580149
  var valid_580150 = query.getOrDefault("fields")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "fields", valid_580150
  var valid_580151 = query.getOrDefault("access_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "access_token", valid_580151
  var valid_580152 = query.getOrDefault("upload_protocol")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "upload_protocol", valid_580152
  var valid_580153 = query.getOrDefault("personFields")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "personFields", valid_580153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580154: Call_PeoplePeopleDeleteContactPhoto_580138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a contact's photo.
  ## 
  let valid = call_580154.validator(path, query, header, formData, body)
  let scheme = call_580154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580154.url(scheme.get, call_580154.host, call_580154.base,
                         call_580154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580154, url, valid)

proc call*(call_580155: Call_PeoplePeopleDeleteContactPhoto_580138;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          personFields: string = ""): Recallable =
  ## peoplePeopleDeleteContactPhoto
  ## Delete a contact's photo.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : Required. The resource name of the contact whose photo will be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   personFields: string
  ##               : Optional. A field mask to restrict which fields on the person are returned. Multiple
  ## fields can be specified by separating them with commas. Defaults to empty
  ## if not set, which will skip the post mutate get. Valid values are:
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
  var path_580156 = newJObject()
  var query_580157 = newJObject()
  add(query_580157, "key", newJString(key))
  add(query_580157, "prettyPrint", newJBool(prettyPrint))
  add(query_580157, "oauth_token", newJString(oauthToken))
  add(query_580157, "$.xgafv", newJString(Xgafv))
  add(query_580157, "alt", newJString(alt))
  add(query_580157, "uploadType", newJString(uploadType))
  add(query_580157, "quotaUser", newJString(quotaUser))
  add(query_580157, "callback", newJString(callback))
  add(path_580156, "resourceName", newJString(resourceName))
  add(query_580157, "fields", newJString(fields))
  add(query_580157, "access_token", newJString(accessToken))
  add(query_580157, "upload_protocol", newJString(uploadProtocol))
  add(query_580157, "personFields", newJString(personFields))
  result = call_580155.call(path_580156, query_580157, nil, nil, nil)

var peoplePeopleDeleteContactPhoto* = Call_PeoplePeopleDeleteContactPhoto_580138(
    name: "peoplePeopleDeleteContactPhoto", meth: HttpMethod.HttpDelete,
    host: "people.googleapis.com", route: "/v1/{resourceName}:deleteContactPhoto",
    validator: validate_PeoplePeopleDeleteContactPhoto_580139, base: "/",
    url: url_PeoplePeopleDeleteContactPhoto_580140, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContact_580158 = ref object of OpenApiRestCall_579373
proc url_PeoplePeopleUpdateContact_580160(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PeoplePeopleUpdateContact_580159(path: JsonNode; query: JsonNode;
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
  var valid_580161 = path.getOrDefault("resourceName")
  valid_580161 = validateParameter(valid_580161, JString, required = true,
                                 default = nil)
  if valid_580161 != nil:
    section.add "resourceName", valid_580161
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updatePersonFields: JString
  ##                     : Required. A field mask to restrict which fields on the person are updated. Multiple
  ## fields can be specified by separating them with commas.
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580162 = query.getOrDefault("key")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "key", valid_580162
  var valid_580163 = query.getOrDefault("prettyPrint")
  valid_580163 = validateParameter(valid_580163, JBool, required = false,
                                 default = newJBool(true))
  if valid_580163 != nil:
    section.add "prettyPrint", valid_580163
  var valid_580164 = query.getOrDefault("oauth_token")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "oauth_token", valid_580164
  var valid_580165 = query.getOrDefault("$.xgafv")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("1"))
  if valid_580165 != nil:
    section.add "$.xgafv", valid_580165
  var valid_580166 = query.getOrDefault("alt")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = newJString("json"))
  if valid_580166 != nil:
    section.add "alt", valid_580166
  var valid_580167 = query.getOrDefault("uploadType")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "uploadType", valid_580167
  var valid_580168 = query.getOrDefault("quotaUser")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "quotaUser", valid_580168
  var valid_580169 = query.getOrDefault("updatePersonFields")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "updatePersonFields", valid_580169
  var valid_580170 = query.getOrDefault("callback")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "callback", valid_580170
  var valid_580171 = query.getOrDefault("fields")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "fields", valid_580171
  var valid_580172 = query.getOrDefault("access_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "access_token", valid_580172
  var valid_580173 = query.getOrDefault("upload_protocol")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "upload_protocol", valid_580173
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

proc call*(call_580175: Call_PeoplePeopleUpdateContact_580158; path: JsonNode;
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
  let valid = call_580175.validator(path, query, header, formData, body)
  let scheme = call_580175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580175.url(scheme.get, call_580175.host, call_580175.base,
                         call_580175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580175, url, valid)

proc call*(call_580176: Call_PeoplePeopleUpdateContact_580158;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          updatePersonFields: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updatePersonFields: string
  ##                     : Required. A field mask to restrict which fields on the person are updated. Multiple
  ## fields can be specified by separating them with commas.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : The resource name for the person, assigned by the server. An ASCII string
  ## with a max length of 27 characters, in the form of
  ## `people/`<var>person_id</var>.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580177 = newJObject()
  var query_580178 = newJObject()
  var body_580179 = newJObject()
  add(query_580178, "key", newJString(key))
  add(query_580178, "prettyPrint", newJBool(prettyPrint))
  add(query_580178, "oauth_token", newJString(oauthToken))
  add(query_580178, "$.xgafv", newJString(Xgafv))
  add(query_580178, "alt", newJString(alt))
  add(query_580178, "uploadType", newJString(uploadType))
  add(query_580178, "quotaUser", newJString(quotaUser))
  add(query_580178, "updatePersonFields", newJString(updatePersonFields))
  if body != nil:
    body_580179 = body
  add(query_580178, "callback", newJString(callback))
  add(path_580177, "resourceName", newJString(resourceName))
  add(query_580178, "fields", newJString(fields))
  add(query_580178, "access_token", newJString(accessToken))
  add(query_580178, "upload_protocol", newJString(uploadProtocol))
  result = call_580176.call(path_580177, query_580178, nil, nil, body_580179)

var peoplePeopleUpdateContact* = Call_PeoplePeopleUpdateContact_580158(
    name: "peoplePeopleUpdateContact", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContact",
    validator: validate_PeoplePeopleUpdateContact_580159, base: "/",
    url: url_PeoplePeopleUpdateContact_580160, schemes: {Scheme.Https})
type
  Call_PeoplePeopleUpdateContactPhoto_580180 = ref object of OpenApiRestCall_579373
proc url_PeoplePeopleUpdateContactPhoto_580182(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_PeoplePeopleUpdateContactPhoto_580181(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a contact's photo.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : Required. Person resource name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580183 = path.getOrDefault("resourceName")
  valid_580183 = validateParameter(valid_580183, JString, required = true,
                                 default = nil)
  if valid_580183 != nil:
    section.add "resourceName", valid_580183
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580184 = query.getOrDefault("key")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "key", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(true))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
  var valid_580186 = query.getOrDefault("oauth_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "oauth_token", valid_580186
  var valid_580187 = query.getOrDefault("$.xgafv")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("1"))
  if valid_580187 != nil:
    section.add "$.xgafv", valid_580187
  var valid_580188 = query.getOrDefault("alt")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = newJString("json"))
  if valid_580188 != nil:
    section.add "alt", valid_580188
  var valid_580189 = query.getOrDefault("uploadType")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "uploadType", valid_580189
  var valid_580190 = query.getOrDefault("quotaUser")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "quotaUser", valid_580190
  var valid_580191 = query.getOrDefault("callback")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "callback", valid_580191
  var valid_580192 = query.getOrDefault("fields")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "fields", valid_580192
  var valid_580193 = query.getOrDefault("access_token")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "access_token", valid_580193
  var valid_580194 = query.getOrDefault("upload_protocol")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "upload_protocol", valid_580194
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

proc call*(call_580196: Call_PeoplePeopleUpdateContactPhoto_580180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a contact's photo.
  ## 
  let valid = call_580196.validator(path, query, header, formData, body)
  let scheme = call_580196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580196.url(scheme.get, call_580196.host, call_580196.base,
                         call_580196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580196, url, valid)

proc call*(call_580197: Call_PeoplePeopleUpdateContactPhoto_580180;
          resourceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## peoplePeopleUpdateContactPhoto
  ## Update a contact's photo.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : Required. Person resource name
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580198 = newJObject()
  var query_580199 = newJObject()
  var body_580200 = newJObject()
  add(query_580199, "key", newJString(key))
  add(query_580199, "prettyPrint", newJBool(prettyPrint))
  add(query_580199, "oauth_token", newJString(oauthToken))
  add(query_580199, "$.xgafv", newJString(Xgafv))
  add(query_580199, "alt", newJString(alt))
  add(query_580199, "uploadType", newJString(uploadType))
  add(query_580199, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580200 = body
  add(query_580199, "callback", newJString(callback))
  add(path_580198, "resourceName", newJString(resourceName))
  add(query_580199, "fields", newJString(fields))
  add(query_580199, "access_token", newJString(accessToken))
  add(query_580199, "upload_protocol", newJString(uploadProtocol))
  result = call_580197.call(path_580198, query_580199, nil, nil, body_580200)

var peoplePeopleUpdateContactPhoto* = Call_PeoplePeopleUpdateContactPhoto_580180(
    name: "peoplePeopleUpdateContactPhoto", meth: HttpMethod.HttpPatch,
    host: "people.googleapis.com", route: "/v1/{resourceName}:updateContactPhoto",
    validator: validate_PeoplePeopleUpdateContactPhoto_580181, base: "/",
    url: url_PeoplePeopleUpdateContactPhoto_580182, schemes: {Scheme.Https})
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
