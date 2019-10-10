
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Mirror
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Interacts with Glass users via the timeline.
## 
## https://developers.google.com/glass
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
  gcpServiceName = "mirror"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MirrorAccountsInsert_588709 = ref object of OpenApiRestCall_588441
proc url_MirrorAccountsInsert_588711(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userToken" in path, "`userToken` is a required path parameter"
  assert "accountType" in path, "`accountType` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "userToken"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "accountType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorAccountsInsert_588710(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new account for a user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountType: JString (required)
  ##              : Account type to be passed to Android Account Manager.
  ##   userToken: JString (required)
  ##            : The ID for the user.
  ##   accountName: JString (required)
  ##              : The name of the account to be passed to the Android Account Manager.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accountType` field"
  var valid_588837 = path.getOrDefault("accountType")
  valid_588837 = validateParameter(valid_588837, JString, required = true,
                                 default = nil)
  if valid_588837 != nil:
    section.add "accountType", valid_588837
  var valid_588838 = path.getOrDefault("userToken")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "userToken", valid_588838
  var valid_588839 = path.getOrDefault("accountName")
  valid_588839 = validateParameter(valid_588839, JString, required = true,
                                 default = nil)
  if valid_588839 != nil:
    section.add "accountName", valid_588839
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_588858 = query.getOrDefault("key")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "key", valid_588858
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_588883: Call_MirrorAccountsInsert_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new account for a user
  ## 
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_MirrorAccountsInsert_588709; accountType: string;
          userToken: string; accountName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## mirrorAccountsInsert
  ## Inserts a new account for a user
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   accountType: string (required)
  ##              : Account type to be passed to Android Account Manager.
  ##   userToken: string (required)
  ##            : The ID for the user.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   accountName: string (required)
  ##              : The name of the account to be passed to the Android Account Manager.
  var path_588955 = newJObject()
  var query_588957 = newJObject()
  var body_588958 = newJObject()
  add(query_588957, "fields", newJString(fields))
  add(query_588957, "quotaUser", newJString(quotaUser))
  add(query_588957, "alt", newJString(alt))
  add(path_588955, "accountType", newJString(accountType))
  add(path_588955, "userToken", newJString(userToken))
  add(query_588957, "oauth_token", newJString(oauthToken))
  add(query_588957, "userIp", newJString(userIp))
  add(query_588957, "key", newJString(key))
  if body != nil:
    body_588958 = body
  add(query_588957, "prettyPrint", newJBool(prettyPrint))
  add(path_588955, "accountName", newJString(accountName))
  result = call_588954.call(path_588955, query_588957, nil, nil, body_588958)

var mirrorAccountsInsert* = Call_MirrorAccountsInsert_588709(
    name: "mirrorAccountsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{userToken}/{accountType}/{accountName}",
    validator: validate_MirrorAccountsInsert_588710, base: "/mirror/v1",
    url: url_MirrorAccountsInsert_588711, schemes: {Scheme.Https})
type
  Call_MirrorContactsInsert_589010 = ref object of OpenApiRestCall_588441
proc url_MirrorContactsInsert_589012(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorContactsInsert_589011(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new contact.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589013 = query.getOrDefault("fields")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "fields", valid_589013
  var valid_589014 = query.getOrDefault("quotaUser")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "quotaUser", valid_589014
  var valid_589015 = query.getOrDefault("alt")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("json"))
  if valid_589015 != nil:
    section.add "alt", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("userIp")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "userIp", valid_589017
  var valid_589018 = query.getOrDefault("key")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "key", valid_589018
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589021: Call_MirrorContactsInsert_589010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new contact.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_MirrorContactsInsert_589010; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## mirrorContactsInsert
  ## Inserts a new contact.
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
  var query_589023 = newJObject()
  var body_589024 = newJObject()
  add(query_589023, "fields", newJString(fields))
  add(query_589023, "quotaUser", newJString(quotaUser))
  add(query_589023, "alt", newJString(alt))
  add(query_589023, "oauth_token", newJString(oauthToken))
  add(query_589023, "userIp", newJString(userIp))
  add(query_589023, "key", newJString(key))
  if body != nil:
    body_589024 = body
  add(query_589023, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(nil, query_589023, nil, nil, body_589024)

var mirrorContactsInsert* = Call_MirrorContactsInsert_589010(
    name: "mirrorContactsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/contacts",
    validator: validate_MirrorContactsInsert_589011, base: "/mirror/v1",
    url: url_MirrorContactsInsert_589012, schemes: {Scheme.Https})
type
  Call_MirrorContactsList_588997 = ref object of OpenApiRestCall_588441
proc url_MirrorContactsList_588999(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorContactsList_588998(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of contacts for the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589000 = query.getOrDefault("fields")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "fields", valid_589000
  var valid_589001 = query.getOrDefault("quotaUser")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "quotaUser", valid_589001
  var valid_589002 = query.getOrDefault("alt")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = newJString("json"))
  if valid_589002 != nil:
    section.add "alt", valid_589002
  var valid_589003 = query.getOrDefault("oauth_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "oauth_token", valid_589003
  var valid_589004 = query.getOrDefault("userIp")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "userIp", valid_589004
  var valid_589005 = query.getOrDefault("key")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "key", valid_589005
  var valid_589006 = query.getOrDefault("prettyPrint")
  valid_589006 = validateParameter(valid_589006, JBool, required = false,
                                 default = newJBool(true))
  if valid_589006 != nil:
    section.add "prettyPrint", valid_589006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589007: Call_MirrorContactsList_588997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of contacts for the authenticated user.
  ## 
  let valid = call_589007.validator(path, query, header, formData, body)
  let scheme = call_589007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589007.url(scheme.get, call_589007.host, call_589007.base,
                         call_589007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589007, url, valid)

proc call*(call_589008: Call_MirrorContactsList_588997; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorContactsList
  ## Retrieves a list of contacts for the authenticated user.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589009 = newJObject()
  add(query_589009, "fields", newJString(fields))
  add(query_589009, "quotaUser", newJString(quotaUser))
  add(query_589009, "alt", newJString(alt))
  add(query_589009, "oauth_token", newJString(oauthToken))
  add(query_589009, "userIp", newJString(userIp))
  add(query_589009, "key", newJString(key))
  add(query_589009, "prettyPrint", newJBool(prettyPrint))
  result = call_589008.call(nil, query_589009, nil, nil, nil)

var mirrorContactsList* = Call_MirrorContactsList_588997(
    name: "mirrorContactsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/contacts",
    validator: validate_MirrorContactsList_588998, base: "/mirror/v1",
    url: url_MirrorContactsList_588999, schemes: {Scheme.Https})
type
  Call_MirrorContactsUpdate_589040 = ref object of OpenApiRestCall_588441
proc url_MirrorContactsUpdate_589042(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/contacts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorContactsUpdate_589041(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a contact in place.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589043 = path.getOrDefault("id")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "id", valid_589043
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589044 = query.getOrDefault("fields")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "fields", valid_589044
  var valid_589045 = query.getOrDefault("quotaUser")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "quotaUser", valid_589045
  var valid_589046 = query.getOrDefault("alt")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = newJString("json"))
  if valid_589046 != nil:
    section.add "alt", valid_589046
  var valid_589047 = query.getOrDefault("oauth_token")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "oauth_token", valid_589047
  var valid_589048 = query.getOrDefault("userIp")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "userIp", valid_589048
  var valid_589049 = query.getOrDefault("key")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "key", valid_589049
  var valid_589050 = query.getOrDefault("prettyPrint")
  valid_589050 = validateParameter(valid_589050, JBool, required = false,
                                 default = newJBool(true))
  if valid_589050 != nil:
    section.add "prettyPrint", valid_589050
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

proc call*(call_589052: Call_MirrorContactsUpdate_589040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a contact in place.
  ## 
  let valid = call_589052.validator(path, query, header, formData, body)
  let scheme = call_589052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589052.url(scheme.get, call_589052.host, call_589052.base,
                         call_589052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589052, url, valid)

proc call*(call_589053: Call_MirrorContactsUpdate_589040; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorContactsUpdate
  ## Updates a contact in place.
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
  ##   id: string (required)
  ##     : The ID of the contact.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589054 = newJObject()
  var query_589055 = newJObject()
  var body_589056 = newJObject()
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(query_589055, "alt", newJString(alt))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "userIp", newJString(userIp))
  add(path_589054, "id", newJString(id))
  add(query_589055, "key", newJString(key))
  if body != nil:
    body_589056 = body
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  result = call_589053.call(path_589054, query_589055, nil, nil, body_589056)

var mirrorContactsUpdate* = Call_MirrorContactsUpdate_589040(
    name: "mirrorContactsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/contacts/{id}",
    validator: validate_MirrorContactsUpdate_589041, base: "/mirror/v1",
    url: url_MirrorContactsUpdate_589042, schemes: {Scheme.Https})
type
  Call_MirrorContactsGet_589025 = ref object of OpenApiRestCall_588441
proc url_MirrorContactsGet_589027(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/contacts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorContactsGet_589026(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a single contact by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589028 = path.getOrDefault("id")
  valid_589028 = validateParameter(valid_589028, JString, required = true,
                                 default = nil)
  if valid_589028 != nil:
    section.add "id", valid_589028
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589029 = query.getOrDefault("fields")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "fields", valid_589029
  var valid_589030 = query.getOrDefault("quotaUser")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "quotaUser", valid_589030
  var valid_589031 = query.getOrDefault("alt")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("json"))
  if valid_589031 != nil:
    section.add "alt", valid_589031
  var valid_589032 = query.getOrDefault("oauth_token")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "oauth_token", valid_589032
  var valid_589033 = query.getOrDefault("userIp")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "userIp", valid_589033
  var valid_589034 = query.getOrDefault("key")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "key", valid_589034
  var valid_589035 = query.getOrDefault("prettyPrint")
  valid_589035 = validateParameter(valid_589035, JBool, required = false,
                                 default = newJBool(true))
  if valid_589035 != nil:
    section.add "prettyPrint", valid_589035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589036: Call_MirrorContactsGet_589025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single contact by ID.
  ## 
  let valid = call_589036.validator(path, query, header, formData, body)
  let scheme = call_589036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589036.url(scheme.get, call_589036.host, call_589036.base,
                         call_589036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589036, url, valid)

proc call*(call_589037: Call_MirrorContactsGet_589025; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorContactsGet
  ## Gets a single contact by ID.
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
  ##   id: string (required)
  ##     : The ID of the contact.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589038 = newJObject()
  var query_589039 = newJObject()
  add(query_589039, "fields", newJString(fields))
  add(query_589039, "quotaUser", newJString(quotaUser))
  add(query_589039, "alt", newJString(alt))
  add(query_589039, "oauth_token", newJString(oauthToken))
  add(query_589039, "userIp", newJString(userIp))
  add(path_589038, "id", newJString(id))
  add(query_589039, "key", newJString(key))
  add(query_589039, "prettyPrint", newJBool(prettyPrint))
  result = call_589037.call(path_589038, query_589039, nil, nil, nil)

var mirrorContactsGet* = Call_MirrorContactsGet_589025(name: "mirrorContactsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/contacts/{id}",
    validator: validate_MirrorContactsGet_589026, base: "/mirror/v1",
    url: url_MirrorContactsGet_589027, schemes: {Scheme.Https})
type
  Call_MirrorContactsPatch_589072 = ref object of OpenApiRestCall_588441
proc url_MirrorContactsPatch_589074(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/contacts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorContactsPatch_589073(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a contact in place. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589075 = path.getOrDefault("id")
  valid_589075 = validateParameter(valid_589075, JString, required = true,
                                 default = nil)
  if valid_589075 != nil:
    section.add "id", valid_589075
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589076 = query.getOrDefault("fields")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "fields", valid_589076
  var valid_589077 = query.getOrDefault("quotaUser")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "quotaUser", valid_589077
  var valid_589078 = query.getOrDefault("alt")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = newJString("json"))
  if valid_589078 != nil:
    section.add "alt", valid_589078
  var valid_589079 = query.getOrDefault("oauth_token")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "oauth_token", valid_589079
  var valid_589080 = query.getOrDefault("userIp")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "userIp", valid_589080
  var valid_589081 = query.getOrDefault("key")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "key", valid_589081
  var valid_589082 = query.getOrDefault("prettyPrint")
  valid_589082 = validateParameter(valid_589082, JBool, required = false,
                                 default = newJBool(true))
  if valid_589082 != nil:
    section.add "prettyPrint", valid_589082
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

proc call*(call_589084: Call_MirrorContactsPatch_589072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a contact in place. This method supports patch semantics.
  ## 
  let valid = call_589084.validator(path, query, header, formData, body)
  let scheme = call_589084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589084.url(scheme.get, call_589084.host, call_589084.base,
                         call_589084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589084, url, valid)

proc call*(call_589085: Call_MirrorContactsPatch_589072; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorContactsPatch
  ## Updates a contact in place. This method supports patch semantics.
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
  ##   id: string (required)
  ##     : The ID of the contact.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589086 = newJObject()
  var query_589087 = newJObject()
  var body_589088 = newJObject()
  add(query_589087, "fields", newJString(fields))
  add(query_589087, "quotaUser", newJString(quotaUser))
  add(query_589087, "alt", newJString(alt))
  add(query_589087, "oauth_token", newJString(oauthToken))
  add(query_589087, "userIp", newJString(userIp))
  add(path_589086, "id", newJString(id))
  add(query_589087, "key", newJString(key))
  if body != nil:
    body_589088 = body
  add(query_589087, "prettyPrint", newJBool(prettyPrint))
  result = call_589085.call(path_589086, query_589087, nil, nil, body_589088)

var mirrorContactsPatch* = Call_MirrorContactsPatch_589072(
    name: "mirrorContactsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/contacts/{id}",
    validator: validate_MirrorContactsPatch_589073, base: "/mirror/v1",
    url: url_MirrorContactsPatch_589074, schemes: {Scheme.Https})
type
  Call_MirrorContactsDelete_589057 = ref object of OpenApiRestCall_588441
proc url_MirrorContactsDelete_589059(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/contacts/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorContactsDelete_589058(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a contact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589060 = path.getOrDefault("id")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "id", valid_589060
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589061 = query.getOrDefault("fields")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "fields", valid_589061
  var valid_589062 = query.getOrDefault("quotaUser")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "quotaUser", valid_589062
  var valid_589063 = query.getOrDefault("alt")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("json"))
  if valid_589063 != nil:
    section.add "alt", valid_589063
  var valid_589064 = query.getOrDefault("oauth_token")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "oauth_token", valid_589064
  var valid_589065 = query.getOrDefault("userIp")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "userIp", valid_589065
  var valid_589066 = query.getOrDefault("key")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "key", valid_589066
  var valid_589067 = query.getOrDefault("prettyPrint")
  valid_589067 = validateParameter(valid_589067, JBool, required = false,
                                 default = newJBool(true))
  if valid_589067 != nil:
    section.add "prettyPrint", valid_589067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589068: Call_MirrorContactsDelete_589057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a contact.
  ## 
  let valid = call_589068.validator(path, query, header, formData, body)
  let scheme = call_589068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589068.url(scheme.get, call_589068.host, call_589068.base,
                         call_589068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589068, url, valid)

proc call*(call_589069: Call_MirrorContactsDelete_589057; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorContactsDelete
  ## Deletes a contact.
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
  ##   id: string (required)
  ##     : The ID of the contact.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589070 = newJObject()
  var query_589071 = newJObject()
  add(query_589071, "fields", newJString(fields))
  add(query_589071, "quotaUser", newJString(quotaUser))
  add(query_589071, "alt", newJString(alt))
  add(query_589071, "oauth_token", newJString(oauthToken))
  add(query_589071, "userIp", newJString(userIp))
  add(path_589070, "id", newJString(id))
  add(query_589071, "key", newJString(key))
  add(query_589071, "prettyPrint", newJBool(prettyPrint))
  result = call_589069.call(path_589070, query_589071, nil, nil, nil)

var mirrorContactsDelete* = Call_MirrorContactsDelete_589057(
    name: "mirrorContactsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/contacts/{id}",
    validator: validate_MirrorContactsDelete_589058, base: "/mirror/v1",
    url: url_MirrorContactsDelete_589059, schemes: {Scheme.Https})
type
  Call_MirrorLocationsList_589089 = ref object of OpenApiRestCall_588441
proc url_MirrorLocationsList_589091(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorLocationsList_589090(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a list of locations for the user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589092 = query.getOrDefault("fields")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "fields", valid_589092
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
  var valid_589096 = query.getOrDefault("userIp")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "userIp", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("prettyPrint")
  valid_589098 = validateParameter(valid_589098, JBool, required = false,
                                 default = newJBool(true))
  if valid_589098 != nil:
    section.add "prettyPrint", valid_589098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589099: Call_MirrorLocationsList_589089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of locations for the user.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_MirrorLocationsList_589089; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorLocationsList
  ## Retrieves a list of locations for the user.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589101 = newJObject()
  add(query_589101, "fields", newJString(fields))
  add(query_589101, "quotaUser", newJString(quotaUser))
  add(query_589101, "alt", newJString(alt))
  add(query_589101, "oauth_token", newJString(oauthToken))
  add(query_589101, "userIp", newJString(userIp))
  add(query_589101, "key", newJString(key))
  add(query_589101, "prettyPrint", newJBool(prettyPrint))
  result = call_589100.call(nil, query_589101, nil, nil, nil)

var mirrorLocationsList* = Call_MirrorLocationsList_589089(
    name: "mirrorLocationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/locations",
    validator: validate_MirrorLocationsList_589090, base: "/mirror/v1",
    url: url_MirrorLocationsList_589091, schemes: {Scheme.Https})
type
  Call_MirrorLocationsGet_589102 = ref object of OpenApiRestCall_588441
proc url_MirrorLocationsGet_589104(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/locations/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorLocationsGet_589103(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a single location by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the location or latest for the last known location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589105 = path.getOrDefault("id")
  valid_589105 = validateParameter(valid_589105, JString, required = true,
                                 default = nil)
  if valid_589105 != nil:
    section.add "id", valid_589105
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589106 = query.getOrDefault("fields")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "fields", valid_589106
  var valid_589107 = query.getOrDefault("quotaUser")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "quotaUser", valid_589107
  var valid_589108 = query.getOrDefault("alt")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("json"))
  if valid_589108 != nil:
    section.add "alt", valid_589108
  var valid_589109 = query.getOrDefault("oauth_token")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "oauth_token", valid_589109
  var valid_589110 = query.getOrDefault("userIp")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "userIp", valid_589110
  var valid_589111 = query.getOrDefault("key")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "key", valid_589111
  var valid_589112 = query.getOrDefault("prettyPrint")
  valid_589112 = validateParameter(valid_589112, JBool, required = false,
                                 default = newJBool(true))
  if valid_589112 != nil:
    section.add "prettyPrint", valid_589112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589113: Call_MirrorLocationsGet_589102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single location by ID.
  ## 
  let valid = call_589113.validator(path, query, header, formData, body)
  let scheme = call_589113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589113.url(scheme.get, call_589113.host, call_589113.base,
                         call_589113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589113, url, valid)

proc call*(call_589114: Call_MirrorLocationsGet_589102; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorLocationsGet
  ## Gets a single location by ID.
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
  ##   id: string (required)
  ##     : The ID of the location or latest for the last known location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589115 = newJObject()
  var query_589116 = newJObject()
  add(query_589116, "fields", newJString(fields))
  add(query_589116, "quotaUser", newJString(quotaUser))
  add(query_589116, "alt", newJString(alt))
  add(query_589116, "oauth_token", newJString(oauthToken))
  add(query_589116, "userIp", newJString(userIp))
  add(path_589115, "id", newJString(id))
  add(query_589116, "key", newJString(key))
  add(query_589116, "prettyPrint", newJBool(prettyPrint))
  result = call_589114.call(path_589115, query_589116, nil, nil, nil)

var mirrorLocationsGet* = Call_MirrorLocationsGet_589102(
    name: "mirrorLocationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/locations/{id}",
    validator: validate_MirrorLocationsGet_589103, base: "/mirror/v1",
    url: url_MirrorLocationsGet_589104, schemes: {Scheme.Https})
type
  Call_MirrorSettingsGet_589117 = ref object of OpenApiRestCall_588441
proc url_MirrorSettingsGet_589119(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/settings/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorSettingsGet_589118(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a single setting by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the setting. The following IDs are valid: 
  ## - locale - The key to the user’s language/locale (BCP 47 identifier) that Glassware should use to render localized content. 
  ## - timezone - The key to the user’s current time zone region as defined in the tz database. Example: America/Los_Angeles.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589120 = path.getOrDefault("id")
  valid_589120 = validateParameter(valid_589120, JString, required = true,
                                 default = nil)
  if valid_589120 != nil:
    section.add "id", valid_589120
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589121 = query.getOrDefault("fields")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "fields", valid_589121
  var valid_589122 = query.getOrDefault("quotaUser")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "quotaUser", valid_589122
  var valid_589123 = query.getOrDefault("alt")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = newJString("json"))
  if valid_589123 != nil:
    section.add "alt", valid_589123
  var valid_589124 = query.getOrDefault("oauth_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "oauth_token", valid_589124
  var valid_589125 = query.getOrDefault("userIp")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "userIp", valid_589125
  var valid_589126 = query.getOrDefault("key")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "key", valid_589126
  var valid_589127 = query.getOrDefault("prettyPrint")
  valid_589127 = validateParameter(valid_589127, JBool, required = false,
                                 default = newJBool(true))
  if valid_589127 != nil:
    section.add "prettyPrint", valid_589127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589128: Call_MirrorSettingsGet_589117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single setting by ID.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_MirrorSettingsGet_589117; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorSettingsGet
  ## Gets a single setting by ID.
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
  ##   id: string (required)
  ##     : The ID of the setting. The following IDs are valid: 
  ## - locale - The key to the user’s language/locale (BCP 47 identifier) that Glassware should use to render localized content. 
  ## - timezone - The key to the user’s current time zone region as defined in the tz database. Example: America/Los_Angeles.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589130 = newJObject()
  var query_589131 = newJObject()
  add(query_589131, "fields", newJString(fields))
  add(query_589131, "quotaUser", newJString(quotaUser))
  add(query_589131, "alt", newJString(alt))
  add(query_589131, "oauth_token", newJString(oauthToken))
  add(query_589131, "userIp", newJString(userIp))
  add(path_589130, "id", newJString(id))
  add(query_589131, "key", newJString(key))
  add(query_589131, "prettyPrint", newJBool(prettyPrint))
  result = call_589129.call(path_589130, query_589131, nil, nil, nil)

var mirrorSettingsGet* = Call_MirrorSettingsGet_589117(name: "mirrorSettingsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/settings/{id}",
    validator: validate_MirrorSettingsGet_589118, base: "/mirror/v1",
    url: url_MirrorSettingsGet_589119, schemes: {Scheme.Https})
type
  Call_MirrorSubscriptionsInsert_589145 = ref object of OpenApiRestCall_588441
proc url_MirrorSubscriptionsInsert_589147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorSubscriptionsInsert_589146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589148 = query.getOrDefault("fields")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "fields", valid_589148
  var valid_589149 = query.getOrDefault("quotaUser")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "quotaUser", valid_589149
  var valid_589150 = query.getOrDefault("alt")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = newJString("json"))
  if valid_589150 != nil:
    section.add "alt", valid_589150
  var valid_589151 = query.getOrDefault("oauth_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "oauth_token", valid_589151
  var valid_589152 = query.getOrDefault("userIp")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "userIp", valid_589152
  var valid_589153 = query.getOrDefault("key")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "key", valid_589153
  var valid_589154 = query.getOrDefault("prettyPrint")
  valid_589154 = validateParameter(valid_589154, JBool, required = false,
                                 default = newJBool(true))
  if valid_589154 != nil:
    section.add "prettyPrint", valid_589154
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

proc call*(call_589156: Call_MirrorSubscriptionsInsert_589145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new subscription.
  ## 
  let valid = call_589156.validator(path, query, header, formData, body)
  let scheme = call_589156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589156.url(scheme.get, call_589156.host, call_589156.base,
                         call_589156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589156, url, valid)

proc call*(call_589157: Call_MirrorSubscriptionsInsert_589145; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## mirrorSubscriptionsInsert
  ## Creates a new subscription.
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
  var query_589158 = newJObject()
  var body_589159 = newJObject()
  add(query_589158, "fields", newJString(fields))
  add(query_589158, "quotaUser", newJString(quotaUser))
  add(query_589158, "alt", newJString(alt))
  add(query_589158, "oauth_token", newJString(oauthToken))
  add(query_589158, "userIp", newJString(userIp))
  add(query_589158, "key", newJString(key))
  if body != nil:
    body_589159 = body
  add(query_589158, "prettyPrint", newJBool(prettyPrint))
  result = call_589157.call(nil, query_589158, nil, nil, body_589159)

var mirrorSubscriptionsInsert* = Call_MirrorSubscriptionsInsert_589145(
    name: "mirrorSubscriptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_MirrorSubscriptionsInsert_589146, base: "/mirror/v1",
    url: url_MirrorSubscriptionsInsert_589147, schemes: {Scheme.Https})
type
  Call_MirrorSubscriptionsList_589132 = ref object of OpenApiRestCall_588441
proc url_MirrorSubscriptionsList_589134(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorSubscriptionsList_589133(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of subscriptions for the authenticated user and service.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589135 = query.getOrDefault("fields")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "fields", valid_589135
  var valid_589136 = query.getOrDefault("quotaUser")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "quotaUser", valid_589136
  var valid_589137 = query.getOrDefault("alt")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("json"))
  if valid_589137 != nil:
    section.add "alt", valid_589137
  var valid_589138 = query.getOrDefault("oauth_token")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "oauth_token", valid_589138
  var valid_589139 = query.getOrDefault("userIp")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "userIp", valid_589139
  var valid_589140 = query.getOrDefault("key")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "key", valid_589140
  var valid_589141 = query.getOrDefault("prettyPrint")
  valid_589141 = validateParameter(valid_589141, JBool, required = false,
                                 default = newJBool(true))
  if valid_589141 != nil:
    section.add "prettyPrint", valid_589141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589142: Call_MirrorSubscriptionsList_589132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of subscriptions for the authenticated user and service.
  ## 
  let valid = call_589142.validator(path, query, header, formData, body)
  let scheme = call_589142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589142.url(scheme.get, call_589142.host, call_589142.base,
                         call_589142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589142, url, valid)

proc call*(call_589143: Call_MirrorSubscriptionsList_589132; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorSubscriptionsList
  ## Retrieves a list of subscriptions for the authenticated user and service.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589144 = newJObject()
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "userIp", newJString(userIp))
  add(query_589144, "key", newJString(key))
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  result = call_589143.call(nil, query_589144, nil, nil, nil)

var mirrorSubscriptionsList* = Call_MirrorSubscriptionsList_589132(
    name: "mirrorSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_MirrorSubscriptionsList_589133, base: "/mirror/v1",
    url: url_MirrorSubscriptionsList_589134, schemes: {Scheme.Https})
type
  Call_MirrorSubscriptionsUpdate_589160 = ref object of OpenApiRestCall_588441
proc url_MirrorSubscriptionsUpdate_589162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorSubscriptionsUpdate_589161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing subscription in place.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589163 = path.getOrDefault("id")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "id", valid_589163
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589164 = query.getOrDefault("fields")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "fields", valid_589164
  var valid_589165 = query.getOrDefault("quotaUser")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "quotaUser", valid_589165
  var valid_589166 = query.getOrDefault("alt")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = newJString("json"))
  if valid_589166 != nil:
    section.add "alt", valid_589166
  var valid_589167 = query.getOrDefault("oauth_token")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "oauth_token", valid_589167
  var valid_589168 = query.getOrDefault("userIp")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "userIp", valid_589168
  var valid_589169 = query.getOrDefault("key")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "key", valid_589169
  var valid_589170 = query.getOrDefault("prettyPrint")
  valid_589170 = validateParameter(valid_589170, JBool, required = false,
                                 default = newJBool(true))
  if valid_589170 != nil:
    section.add "prettyPrint", valid_589170
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

proc call*(call_589172: Call_MirrorSubscriptionsUpdate_589160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing subscription in place.
  ## 
  let valid = call_589172.validator(path, query, header, formData, body)
  let scheme = call_589172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589172.url(scheme.get, call_589172.host, call_589172.base,
                         call_589172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589172, url, valid)

proc call*(call_589173: Call_MirrorSubscriptionsUpdate_589160; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorSubscriptionsUpdate
  ## Updates an existing subscription in place.
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
  ##   id: string (required)
  ##     : The ID of the subscription.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589174 = newJObject()
  var query_589175 = newJObject()
  var body_589176 = newJObject()
  add(query_589175, "fields", newJString(fields))
  add(query_589175, "quotaUser", newJString(quotaUser))
  add(query_589175, "alt", newJString(alt))
  add(query_589175, "oauth_token", newJString(oauthToken))
  add(query_589175, "userIp", newJString(userIp))
  add(path_589174, "id", newJString(id))
  add(query_589175, "key", newJString(key))
  if body != nil:
    body_589176 = body
  add(query_589175, "prettyPrint", newJBool(prettyPrint))
  result = call_589173.call(path_589174, query_589175, nil, nil, body_589176)

var mirrorSubscriptionsUpdate* = Call_MirrorSubscriptionsUpdate_589160(
    name: "mirrorSubscriptionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/subscriptions/{id}",
    validator: validate_MirrorSubscriptionsUpdate_589161, base: "/mirror/v1",
    url: url_MirrorSubscriptionsUpdate_589162, schemes: {Scheme.Https})
type
  Call_MirrorSubscriptionsDelete_589177 = ref object of OpenApiRestCall_588441
proc url_MirrorSubscriptionsDelete_589179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorSubscriptionsDelete_589178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589180 = path.getOrDefault("id")
  valid_589180 = validateParameter(valid_589180, JString, required = true,
                                 default = nil)
  if valid_589180 != nil:
    section.add "id", valid_589180
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589181 = query.getOrDefault("fields")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "fields", valid_589181
  var valid_589182 = query.getOrDefault("quotaUser")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "quotaUser", valid_589182
  var valid_589183 = query.getOrDefault("alt")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("json"))
  if valid_589183 != nil:
    section.add "alt", valid_589183
  var valid_589184 = query.getOrDefault("oauth_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "oauth_token", valid_589184
  var valid_589185 = query.getOrDefault("userIp")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "userIp", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("prettyPrint")
  valid_589187 = validateParameter(valid_589187, JBool, required = false,
                                 default = newJBool(true))
  if valid_589187 != nil:
    section.add "prettyPrint", valid_589187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589188: Call_MirrorSubscriptionsDelete_589177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a subscription.
  ## 
  let valid = call_589188.validator(path, query, header, formData, body)
  let scheme = call_589188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589188.url(scheme.get, call_589188.host, call_589188.base,
                         call_589188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589188, url, valid)

proc call*(call_589189: Call_MirrorSubscriptionsDelete_589177; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorSubscriptionsDelete
  ## Deletes a subscription.
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
  ##   id: string (required)
  ##     : The ID of the subscription.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589190 = newJObject()
  var query_589191 = newJObject()
  add(query_589191, "fields", newJString(fields))
  add(query_589191, "quotaUser", newJString(quotaUser))
  add(query_589191, "alt", newJString(alt))
  add(query_589191, "oauth_token", newJString(oauthToken))
  add(query_589191, "userIp", newJString(userIp))
  add(path_589190, "id", newJString(id))
  add(query_589191, "key", newJString(key))
  add(query_589191, "prettyPrint", newJBool(prettyPrint))
  result = call_589189.call(path_589190, query_589191, nil, nil, nil)

var mirrorSubscriptionsDelete* = Call_MirrorSubscriptionsDelete_589177(
    name: "mirrorSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/subscriptions/{id}",
    validator: validate_MirrorSubscriptionsDelete_589178, base: "/mirror/v1",
    url: url_MirrorSubscriptionsDelete_589179, schemes: {Scheme.Https})
type
  Call_MirrorTimelineInsert_589212 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelineInsert_589214(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorTimelineInsert_589213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new item into the timeline.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589215 = query.getOrDefault("fields")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "fields", valid_589215
  var valid_589216 = query.getOrDefault("quotaUser")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "quotaUser", valid_589216
  var valid_589217 = query.getOrDefault("alt")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("json"))
  if valid_589217 != nil:
    section.add "alt", valid_589217
  var valid_589218 = query.getOrDefault("oauth_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "oauth_token", valid_589218
  var valid_589219 = query.getOrDefault("userIp")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "userIp", valid_589219
  var valid_589220 = query.getOrDefault("key")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "key", valid_589220
  var valid_589221 = query.getOrDefault("prettyPrint")
  valid_589221 = validateParameter(valid_589221, JBool, required = false,
                                 default = newJBool(true))
  if valid_589221 != nil:
    section.add "prettyPrint", valid_589221
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

proc call*(call_589223: Call_MirrorTimelineInsert_589212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new item into the timeline.
  ## 
  let valid = call_589223.validator(path, query, header, formData, body)
  let scheme = call_589223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589223.url(scheme.get, call_589223.host, call_589223.base,
                         call_589223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589223, url, valid)

proc call*(call_589224: Call_MirrorTimelineInsert_589212; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## mirrorTimelineInsert
  ## Inserts a new item into the timeline.
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
  var query_589225 = newJObject()
  var body_589226 = newJObject()
  add(query_589225, "fields", newJString(fields))
  add(query_589225, "quotaUser", newJString(quotaUser))
  add(query_589225, "alt", newJString(alt))
  add(query_589225, "oauth_token", newJString(oauthToken))
  add(query_589225, "userIp", newJString(userIp))
  add(query_589225, "key", newJString(key))
  if body != nil:
    body_589226 = body
  add(query_589225, "prettyPrint", newJBool(prettyPrint))
  result = call_589224.call(nil, query_589225, nil, nil, body_589226)

var mirrorTimelineInsert* = Call_MirrorTimelineInsert_589212(
    name: "mirrorTimelineInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/timeline",
    validator: validate_MirrorTimelineInsert_589213, base: "/mirror/v1",
    url: url_MirrorTimelineInsert_589214, schemes: {Scheme.Https})
type
  Call_MirrorTimelineList_589192 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelineList_589194(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MirrorTimelineList_589193(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of timeline items for the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token for the page of results to return.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   bundleId: JString
  ##           : If provided, only items with the given bundleId will be returned.
  ##   maxResults: JInt
  ##             : The maximum number of items to include in the response, used for paging.
  ##   orderBy: JString
  ##          : Controls the order in which timeline items are returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: JBool
  ##                 : If true, tombstone records for deleted items will be returned.
  ##   pinnedOnly: JBool
  ##             : If true, only pinned items will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   sourceItemId: JString
  ##               : If provided, only items with the given sourceItemId will be returned.
  section = newJObject()
  var valid_589195 = query.getOrDefault("fields")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "fields", valid_589195
  var valid_589196 = query.getOrDefault("pageToken")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "pageToken", valid_589196
  var valid_589197 = query.getOrDefault("quotaUser")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "quotaUser", valid_589197
  var valid_589198 = query.getOrDefault("alt")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = newJString("json"))
  if valid_589198 != nil:
    section.add "alt", valid_589198
  var valid_589199 = query.getOrDefault("oauth_token")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "oauth_token", valid_589199
  var valid_589200 = query.getOrDefault("userIp")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "userIp", valid_589200
  var valid_589201 = query.getOrDefault("bundleId")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "bundleId", valid_589201
  var valid_589202 = query.getOrDefault("maxResults")
  valid_589202 = validateParameter(valid_589202, JInt, required = false, default = nil)
  if valid_589202 != nil:
    section.add "maxResults", valid_589202
  var valid_589203 = query.getOrDefault("orderBy")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = newJString("displayTime"))
  if valid_589203 != nil:
    section.add "orderBy", valid_589203
  var valid_589204 = query.getOrDefault("key")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "key", valid_589204
  var valid_589205 = query.getOrDefault("includeDeleted")
  valid_589205 = validateParameter(valid_589205, JBool, required = false, default = nil)
  if valid_589205 != nil:
    section.add "includeDeleted", valid_589205
  var valid_589206 = query.getOrDefault("pinnedOnly")
  valid_589206 = validateParameter(valid_589206, JBool, required = false, default = nil)
  if valid_589206 != nil:
    section.add "pinnedOnly", valid_589206
  var valid_589207 = query.getOrDefault("prettyPrint")
  valid_589207 = validateParameter(valid_589207, JBool, required = false,
                                 default = newJBool(true))
  if valid_589207 != nil:
    section.add "prettyPrint", valid_589207
  var valid_589208 = query.getOrDefault("sourceItemId")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "sourceItemId", valid_589208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589209: Call_MirrorTimelineList_589192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of timeline items for the authenticated user.
  ## 
  let valid = call_589209.validator(path, query, header, formData, body)
  let scheme = call_589209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589209.url(scheme.get, call_589209.host, call_589209.base,
                         call_589209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589209, url, valid)

proc call*(call_589210: Call_MirrorTimelineList_589192; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; bundleId: string = "";
          maxResults: int = 0; orderBy: string = "displayTime"; key: string = "";
          includeDeleted: bool = false; pinnedOnly: bool = false;
          prettyPrint: bool = true; sourceItemId: string = ""): Recallable =
  ## mirrorTimelineList
  ## Retrieves a list of timeline items for the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token for the page of results to return.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   bundleId: string
  ##           : If provided, only items with the given bundleId will be returned.
  ##   maxResults: int
  ##             : The maximum number of items to include in the response, used for paging.
  ##   orderBy: string
  ##          : Controls the order in which timeline items are returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeDeleted: bool
  ##                 : If true, tombstone records for deleted items will be returned.
  ##   pinnedOnly: bool
  ##             : If true, only pinned items will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   sourceItemId: string
  ##               : If provided, only items with the given sourceItemId will be returned.
  var query_589211 = newJObject()
  add(query_589211, "fields", newJString(fields))
  add(query_589211, "pageToken", newJString(pageToken))
  add(query_589211, "quotaUser", newJString(quotaUser))
  add(query_589211, "alt", newJString(alt))
  add(query_589211, "oauth_token", newJString(oauthToken))
  add(query_589211, "userIp", newJString(userIp))
  add(query_589211, "bundleId", newJString(bundleId))
  add(query_589211, "maxResults", newJInt(maxResults))
  add(query_589211, "orderBy", newJString(orderBy))
  add(query_589211, "key", newJString(key))
  add(query_589211, "includeDeleted", newJBool(includeDeleted))
  add(query_589211, "pinnedOnly", newJBool(pinnedOnly))
  add(query_589211, "prettyPrint", newJBool(prettyPrint))
  add(query_589211, "sourceItemId", newJString(sourceItemId))
  result = call_589210.call(nil, query_589211, nil, nil, nil)

var mirrorTimelineList* = Call_MirrorTimelineList_589192(
    name: "mirrorTimelineList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/timeline",
    validator: validate_MirrorTimelineList_589193, base: "/mirror/v1",
    url: url_MirrorTimelineList_589194, schemes: {Scheme.Https})
type
  Call_MirrorTimelineUpdate_589242 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelineUpdate_589244(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineUpdate_589243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a timeline item in place.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the timeline item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589245 = path.getOrDefault("id")
  valid_589245 = validateParameter(valid_589245, JString, required = true,
                                 default = nil)
  if valid_589245 != nil:
    section.add "id", valid_589245
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589246 = query.getOrDefault("fields")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "fields", valid_589246
  var valid_589247 = query.getOrDefault("quotaUser")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "quotaUser", valid_589247
  var valid_589248 = query.getOrDefault("alt")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = newJString("json"))
  if valid_589248 != nil:
    section.add "alt", valid_589248
  var valid_589249 = query.getOrDefault("oauth_token")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "oauth_token", valid_589249
  var valid_589250 = query.getOrDefault("userIp")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "userIp", valid_589250
  var valid_589251 = query.getOrDefault("key")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "key", valid_589251
  var valid_589252 = query.getOrDefault("prettyPrint")
  valid_589252 = validateParameter(valid_589252, JBool, required = false,
                                 default = newJBool(true))
  if valid_589252 != nil:
    section.add "prettyPrint", valid_589252
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

proc call*(call_589254: Call_MirrorTimelineUpdate_589242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a timeline item in place.
  ## 
  let valid = call_589254.validator(path, query, header, formData, body)
  let scheme = call_589254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589254.url(scheme.get, call_589254.host, call_589254.base,
                         call_589254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589254, url, valid)

proc call*(call_589255: Call_MirrorTimelineUpdate_589242; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorTimelineUpdate
  ## Updates a timeline item in place.
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
  ##   id: string (required)
  ##     : The ID of the timeline item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589256 = newJObject()
  var query_589257 = newJObject()
  var body_589258 = newJObject()
  add(query_589257, "fields", newJString(fields))
  add(query_589257, "quotaUser", newJString(quotaUser))
  add(query_589257, "alt", newJString(alt))
  add(query_589257, "oauth_token", newJString(oauthToken))
  add(query_589257, "userIp", newJString(userIp))
  add(path_589256, "id", newJString(id))
  add(query_589257, "key", newJString(key))
  if body != nil:
    body_589258 = body
  add(query_589257, "prettyPrint", newJBool(prettyPrint))
  result = call_589255.call(path_589256, query_589257, nil, nil, body_589258)

var mirrorTimelineUpdate* = Call_MirrorTimelineUpdate_589242(
    name: "mirrorTimelineUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/timeline/{id}",
    validator: validate_MirrorTimelineUpdate_589243, base: "/mirror/v1",
    url: url_MirrorTimelineUpdate_589244, schemes: {Scheme.Https})
type
  Call_MirrorTimelineGet_589227 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelineGet_589229(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineGet_589228(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a single timeline item by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the timeline item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589230 = path.getOrDefault("id")
  valid_589230 = validateParameter(valid_589230, JString, required = true,
                                 default = nil)
  if valid_589230 != nil:
    section.add "id", valid_589230
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589231 = query.getOrDefault("fields")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "fields", valid_589231
  var valid_589232 = query.getOrDefault("quotaUser")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "quotaUser", valid_589232
  var valid_589233 = query.getOrDefault("alt")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("json"))
  if valid_589233 != nil:
    section.add "alt", valid_589233
  var valid_589234 = query.getOrDefault("oauth_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "oauth_token", valid_589234
  var valid_589235 = query.getOrDefault("userIp")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "userIp", valid_589235
  var valid_589236 = query.getOrDefault("key")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "key", valid_589236
  var valid_589237 = query.getOrDefault("prettyPrint")
  valid_589237 = validateParameter(valid_589237, JBool, required = false,
                                 default = newJBool(true))
  if valid_589237 != nil:
    section.add "prettyPrint", valid_589237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589238: Call_MirrorTimelineGet_589227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single timeline item by ID.
  ## 
  let valid = call_589238.validator(path, query, header, formData, body)
  let scheme = call_589238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589238.url(scheme.get, call_589238.host, call_589238.base,
                         call_589238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589238, url, valid)

proc call*(call_589239: Call_MirrorTimelineGet_589227; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorTimelineGet
  ## Gets a single timeline item by ID.
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
  ##   id: string (required)
  ##     : The ID of the timeline item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589240 = newJObject()
  var query_589241 = newJObject()
  add(query_589241, "fields", newJString(fields))
  add(query_589241, "quotaUser", newJString(quotaUser))
  add(query_589241, "alt", newJString(alt))
  add(query_589241, "oauth_token", newJString(oauthToken))
  add(query_589241, "userIp", newJString(userIp))
  add(path_589240, "id", newJString(id))
  add(query_589241, "key", newJString(key))
  add(query_589241, "prettyPrint", newJBool(prettyPrint))
  result = call_589239.call(path_589240, query_589241, nil, nil, nil)

var mirrorTimelineGet* = Call_MirrorTimelineGet_589227(name: "mirrorTimelineGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/timeline/{id}",
    validator: validate_MirrorTimelineGet_589228, base: "/mirror/v1",
    url: url_MirrorTimelineGet_589229, schemes: {Scheme.Https})
type
  Call_MirrorTimelinePatch_589274 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelinePatch_589276(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelinePatch_589275(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a timeline item in place. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the timeline item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589277 = path.getOrDefault("id")
  valid_589277 = validateParameter(valid_589277, JString, required = true,
                                 default = nil)
  if valid_589277 != nil:
    section.add "id", valid_589277
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589278 = query.getOrDefault("fields")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "fields", valid_589278
  var valid_589279 = query.getOrDefault("quotaUser")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "quotaUser", valid_589279
  var valid_589280 = query.getOrDefault("alt")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = newJString("json"))
  if valid_589280 != nil:
    section.add "alt", valid_589280
  var valid_589281 = query.getOrDefault("oauth_token")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "oauth_token", valid_589281
  var valid_589282 = query.getOrDefault("userIp")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "userIp", valid_589282
  var valid_589283 = query.getOrDefault("key")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "key", valid_589283
  var valid_589284 = query.getOrDefault("prettyPrint")
  valid_589284 = validateParameter(valid_589284, JBool, required = false,
                                 default = newJBool(true))
  if valid_589284 != nil:
    section.add "prettyPrint", valid_589284
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

proc call*(call_589286: Call_MirrorTimelinePatch_589274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a timeline item in place. This method supports patch semantics.
  ## 
  let valid = call_589286.validator(path, query, header, formData, body)
  let scheme = call_589286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589286.url(scheme.get, call_589286.host, call_589286.base,
                         call_589286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589286, url, valid)

proc call*(call_589287: Call_MirrorTimelinePatch_589274; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## mirrorTimelinePatch
  ## Updates a timeline item in place. This method supports patch semantics.
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
  ##   id: string (required)
  ##     : The ID of the timeline item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589288 = newJObject()
  var query_589289 = newJObject()
  var body_589290 = newJObject()
  add(query_589289, "fields", newJString(fields))
  add(query_589289, "quotaUser", newJString(quotaUser))
  add(query_589289, "alt", newJString(alt))
  add(query_589289, "oauth_token", newJString(oauthToken))
  add(query_589289, "userIp", newJString(userIp))
  add(path_589288, "id", newJString(id))
  add(query_589289, "key", newJString(key))
  if body != nil:
    body_589290 = body
  add(query_589289, "prettyPrint", newJBool(prettyPrint))
  result = call_589287.call(path_589288, query_589289, nil, nil, body_589290)

var mirrorTimelinePatch* = Call_MirrorTimelinePatch_589274(
    name: "mirrorTimelinePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/timeline/{id}",
    validator: validate_MirrorTimelinePatch_589275, base: "/mirror/v1",
    url: url_MirrorTimelinePatch_589276, schemes: {Scheme.Https})
type
  Call_MirrorTimelineDelete_589259 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelineDelete_589261(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineDelete_589260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a timeline item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the timeline item.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589262 = path.getOrDefault("id")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "id", valid_589262
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589263 = query.getOrDefault("fields")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "fields", valid_589263
  var valid_589264 = query.getOrDefault("quotaUser")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "quotaUser", valid_589264
  var valid_589265 = query.getOrDefault("alt")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = newJString("json"))
  if valid_589265 != nil:
    section.add "alt", valid_589265
  var valid_589266 = query.getOrDefault("oauth_token")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "oauth_token", valid_589266
  var valid_589267 = query.getOrDefault("userIp")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "userIp", valid_589267
  var valid_589268 = query.getOrDefault("key")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "key", valid_589268
  var valid_589269 = query.getOrDefault("prettyPrint")
  valid_589269 = validateParameter(valid_589269, JBool, required = false,
                                 default = newJBool(true))
  if valid_589269 != nil:
    section.add "prettyPrint", valid_589269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589270: Call_MirrorTimelineDelete_589259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a timeline item.
  ## 
  let valid = call_589270.validator(path, query, header, formData, body)
  let scheme = call_589270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589270.url(scheme.get, call_589270.host, call_589270.base,
                         call_589270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589270, url, valid)

proc call*(call_589271: Call_MirrorTimelineDelete_589259; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorTimelineDelete
  ## Deletes a timeline item.
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
  ##   id: string (required)
  ##     : The ID of the timeline item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589272 = newJObject()
  var query_589273 = newJObject()
  add(query_589273, "fields", newJString(fields))
  add(query_589273, "quotaUser", newJString(quotaUser))
  add(query_589273, "alt", newJString(alt))
  add(query_589273, "oauth_token", newJString(oauthToken))
  add(query_589273, "userIp", newJString(userIp))
  add(path_589272, "id", newJString(id))
  add(query_589273, "key", newJString(key))
  add(query_589273, "prettyPrint", newJBool(prettyPrint))
  result = call_589271.call(path_589272, query_589273, nil, nil, nil)

var mirrorTimelineDelete* = Call_MirrorTimelineDelete_589259(
    name: "mirrorTimelineDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/timeline/{id}",
    validator: validate_MirrorTimelineDelete_589260, base: "/mirror/v1",
    url: url_MirrorTimelineDelete_589261, schemes: {Scheme.Https})
type
  Call_MirrorTimelineAttachmentsInsert_589306 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelineAttachmentsInsert_589308(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "itemId"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineAttachmentsInsert_589307(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new attachment to a timeline item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   itemId: JString (required)
  ##         : The ID of the timeline item the attachment belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `itemId` field"
  var valid_589309 = path.getOrDefault("itemId")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "itemId", valid_589309
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589310 = query.getOrDefault("fields")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "fields", valid_589310
  var valid_589311 = query.getOrDefault("quotaUser")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "quotaUser", valid_589311
  var valid_589312 = query.getOrDefault("alt")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = newJString("json"))
  if valid_589312 != nil:
    section.add "alt", valid_589312
  var valid_589313 = query.getOrDefault("oauth_token")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "oauth_token", valid_589313
  var valid_589314 = query.getOrDefault("userIp")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "userIp", valid_589314
  var valid_589315 = query.getOrDefault("key")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "key", valid_589315
  var valid_589316 = query.getOrDefault("prettyPrint")
  valid_589316 = validateParameter(valid_589316, JBool, required = false,
                                 default = newJBool(true))
  if valid_589316 != nil:
    section.add "prettyPrint", valid_589316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589317: Call_MirrorTimelineAttachmentsInsert_589306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new attachment to a timeline item.
  ## 
  let valid = call_589317.validator(path, query, header, formData, body)
  let scheme = call_589317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589317.url(scheme.get, call_589317.host, call_589317.base,
                         call_589317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589317, url, valid)

proc call*(call_589318: Call_MirrorTimelineAttachmentsInsert_589306;
          itemId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorTimelineAttachmentsInsert
  ## Adds a new attachment to a timeline item.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   itemId: string (required)
  ##         : The ID of the timeline item the attachment belongs to.
  var path_589319 = newJObject()
  var query_589320 = newJObject()
  add(query_589320, "fields", newJString(fields))
  add(query_589320, "quotaUser", newJString(quotaUser))
  add(query_589320, "alt", newJString(alt))
  add(query_589320, "oauth_token", newJString(oauthToken))
  add(query_589320, "userIp", newJString(userIp))
  add(query_589320, "key", newJString(key))
  add(query_589320, "prettyPrint", newJBool(prettyPrint))
  add(path_589319, "itemId", newJString(itemId))
  result = call_589318.call(path_589319, query_589320, nil, nil, nil)

var mirrorTimelineAttachmentsInsert* = Call_MirrorTimelineAttachmentsInsert_589306(
    name: "mirrorTimelineAttachmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/timeline/{itemId}/attachments",
    validator: validate_MirrorTimelineAttachmentsInsert_589307,
    base: "/mirror/v1", url: url_MirrorTimelineAttachmentsInsert_589308,
    schemes: {Scheme.Https})
type
  Call_MirrorTimelineAttachmentsList_589291 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelineAttachmentsList_589293(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "itemId" in path, "`itemId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "itemId"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineAttachmentsList_589292(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of attachments for a timeline item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   itemId: JString (required)
  ##         : The ID of the timeline item whose attachments should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `itemId` field"
  var valid_589294 = path.getOrDefault("itemId")
  valid_589294 = validateParameter(valid_589294, JString, required = true,
                                 default = nil)
  if valid_589294 != nil:
    section.add "itemId", valid_589294
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589295 = query.getOrDefault("fields")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "fields", valid_589295
  var valid_589296 = query.getOrDefault("quotaUser")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "quotaUser", valid_589296
  var valid_589297 = query.getOrDefault("alt")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("json"))
  if valid_589297 != nil:
    section.add "alt", valid_589297
  var valid_589298 = query.getOrDefault("oauth_token")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "oauth_token", valid_589298
  var valid_589299 = query.getOrDefault("userIp")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "userIp", valid_589299
  var valid_589300 = query.getOrDefault("key")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "key", valid_589300
  var valid_589301 = query.getOrDefault("prettyPrint")
  valid_589301 = validateParameter(valid_589301, JBool, required = false,
                                 default = newJBool(true))
  if valid_589301 != nil:
    section.add "prettyPrint", valid_589301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589302: Call_MirrorTimelineAttachmentsList_589291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of attachments for a timeline item.
  ## 
  let valid = call_589302.validator(path, query, header, formData, body)
  let scheme = call_589302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589302.url(scheme.get, call_589302.host, call_589302.base,
                         call_589302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589302, url, valid)

proc call*(call_589303: Call_MirrorTimelineAttachmentsList_589291; itemId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## mirrorTimelineAttachmentsList
  ## Returns a list of attachments for a timeline item.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   itemId: string (required)
  ##         : The ID of the timeline item whose attachments should be listed.
  var path_589304 = newJObject()
  var query_589305 = newJObject()
  add(query_589305, "fields", newJString(fields))
  add(query_589305, "quotaUser", newJString(quotaUser))
  add(query_589305, "alt", newJString(alt))
  add(query_589305, "oauth_token", newJString(oauthToken))
  add(query_589305, "userIp", newJString(userIp))
  add(query_589305, "key", newJString(key))
  add(query_589305, "prettyPrint", newJBool(prettyPrint))
  add(path_589304, "itemId", newJString(itemId))
  result = call_589303.call(path_589304, query_589305, nil, nil, nil)

var mirrorTimelineAttachmentsList* = Call_MirrorTimelineAttachmentsList_589291(
    name: "mirrorTimelineAttachmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/timeline/{itemId}/attachments",
    validator: validate_MirrorTimelineAttachmentsList_589292, base: "/mirror/v1",
    url: url_MirrorTimelineAttachmentsList_589293, schemes: {Scheme.Https})
type
  Call_MirrorTimelineAttachmentsGet_589321 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelineAttachmentsGet_589323(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "itemId" in path, "`itemId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "itemId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineAttachmentsGet_589322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an attachment on a timeline item by item ID and attachment ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentId: JString (required)
  ##               : The ID of the attachment.
  ##   itemId: JString (required)
  ##         : The ID of the timeline item the attachment belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentId` field"
  var valid_589324 = path.getOrDefault("attachmentId")
  valid_589324 = validateParameter(valid_589324, JString, required = true,
                                 default = nil)
  if valid_589324 != nil:
    section.add "attachmentId", valid_589324
  var valid_589325 = path.getOrDefault("itemId")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "itemId", valid_589325
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589326 = query.getOrDefault("fields")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "fields", valid_589326
  var valid_589327 = query.getOrDefault("quotaUser")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "quotaUser", valid_589327
  var valid_589328 = query.getOrDefault("alt")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = newJString("json"))
  if valid_589328 != nil:
    section.add "alt", valid_589328
  var valid_589329 = query.getOrDefault("oauth_token")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "oauth_token", valid_589329
  var valid_589330 = query.getOrDefault("userIp")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "userIp", valid_589330
  var valid_589331 = query.getOrDefault("key")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "key", valid_589331
  var valid_589332 = query.getOrDefault("prettyPrint")
  valid_589332 = validateParameter(valid_589332, JBool, required = false,
                                 default = newJBool(true))
  if valid_589332 != nil:
    section.add "prettyPrint", valid_589332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589333: Call_MirrorTimelineAttachmentsGet_589321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an attachment on a timeline item by item ID and attachment ID.
  ## 
  let valid = call_589333.validator(path, query, header, formData, body)
  let scheme = call_589333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589333.url(scheme.get, call_589333.host, call_589333.base,
                         call_589333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589333, url, valid)

proc call*(call_589334: Call_MirrorTimelineAttachmentsGet_589321;
          attachmentId: string; itemId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorTimelineAttachmentsGet
  ## Retrieves an attachment on a timeline item by item ID and attachment ID.
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
  ##   attachmentId: string (required)
  ##               : The ID of the attachment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   itemId: string (required)
  ##         : The ID of the timeline item the attachment belongs to.
  var path_589335 = newJObject()
  var query_589336 = newJObject()
  add(query_589336, "fields", newJString(fields))
  add(query_589336, "quotaUser", newJString(quotaUser))
  add(query_589336, "alt", newJString(alt))
  add(query_589336, "oauth_token", newJString(oauthToken))
  add(query_589336, "userIp", newJString(userIp))
  add(path_589335, "attachmentId", newJString(attachmentId))
  add(query_589336, "key", newJString(key))
  add(query_589336, "prettyPrint", newJBool(prettyPrint))
  add(path_589335, "itemId", newJString(itemId))
  result = call_589334.call(path_589335, query_589336, nil, nil, nil)

var mirrorTimelineAttachmentsGet* = Call_MirrorTimelineAttachmentsGet_589321(
    name: "mirrorTimelineAttachmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/timeline/{itemId}/attachments/{attachmentId}",
    validator: validate_MirrorTimelineAttachmentsGet_589322, base: "/mirror/v1",
    url: url_MirrorTimelineAttachmentsGet_589323, schemes: {Scheme.Https})
type
  Call_MirrorTimelineAttachmentsDelete_589337 = ref object of OpenApiRestCall_588441
proc url_MirrorTimelineAttachmentsDelete_589339(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "itemId" in path, "`itemId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/timeline/"),
               (kind: VariableSegment, value: "itemId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MirrorTimelineAttachmentsDelete_589338(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an attachment from a timeline item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentId: JString (required)
  ##               : The ID of the attachment.
  ##   itemId: JString (required)
  ##         : The ID of the timeline item the attachment belongs to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentId` field"
  var valid_589340 = path.getOrDefault("attachmentId")
  valid_589340 = validateParameter(valid_589340, JString, required = true,
                                 default = nil)
  if valid_589340 != nil:
    section.add "attachmentId", valid_589340
  var valid_589341 = path.getOrDefault("itemId")
  valid_589341 = validateParameter(valid_589341, JString, required = true,
                                 default = nil)
  if valid_589341 != nil:
    section.add "itemId", valid_589341
  result.add "path", section
  ## parameters in `query` object:
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
  var valid_589342 = query.getOrDefault("fields")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "fields", valid_589342
  var valid_589343 = query.getOrDefault("quotaUser")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "quotaUser", valid_589343
  var valid_589344 = query.getOrDefault("alt")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = newJString("json"))
  if valid_589344 != nil:
    section.add "alt", valid_589344
  var valid_589345 = query.getOrDefault("oauth_token")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "oauth_token", valid_589345
  var valid_589346 = query.getOrDefault("userIp")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "userIp", valid_589346
  var valid_589347 = query.getOrDefault("key")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "key", valid_589347
  var valid_589348 = query.getOrDefault("prettyPrint")
  valid_589348 = validateParameter(valid_589348, JBool, required = false,
                                 default = newJBool(true))
  if valid_589348 != nil:
    section.add "prettyPrint", valid_589348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589349: Call_MirrorTimelineAttachmentsDelete_589337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an attachment from a timeline item.
  ## 
  let valid = call_589349.validator(path, query, header, formData, body)
  let scheme = call_589349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589349.url(scheme.get, call_589349.host, call_589349.base,
                         call_589349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589349, url, valid)

proc call*(call_589350: Call_MirrorTimelineAttachmentsDelete_589337;
          attachmentId: string; itemId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## mirrorTimelineAttachmentsDelete
  ## Deletes an attachment from a timeline item.
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
  ##   attachmentId: string (required)
  ##               : The ID of the attachment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   itemId: string (required)
  ##         : The ID of the timeline item the attachment belongs to.
  var path_589351 = newJObject()
  var query_589352 = newJObject()
  add(query_589352, "fields", newJString(fields))
  add(query_589352, "quotaUser", newJString(quotaUser))
  add(query_589352, "alt", newJString(alt))
  add(query_589352, "oauth_token", newJString(oauthToken))
  add(query_589352, "userIp", newJString(userIp))
  add(path_589351, "attachmentId", newJString(attachmentId))
  add(query_589352, "key", newJString(key))
  add(query_589352, "prettyPrint", newJBool(prettyPrint))
  add(path_589351, "itemId", newJString(itemId))
  result = call_589350.call(path_589351, query_589352, nil, nil, nil)

var mirrorTimelineAttachmentsDelete* = Call_MirrorTimelineAttachmentsDelete_589337(
    name: "mirrorTimelineAttachmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/timeline/{itemId}/attachments/{attachmentId}",
    validator: validate_MirrorTimelineAttachmentsDelete_589338,
    base: "/mirror/v1", url: url_MirrorTimelineAttachmentsDelete_589339,
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
