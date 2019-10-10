
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Civic Information
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides polling places, early vote locations, contest data, election officials, and government representatives for U.S. residential addresses.
## 
## https://developers.google.com/civic-information
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
  gcpServiceName = "civicinfo"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CivicinfoDivisionsSearch_588709 = ref object of OpenApiRestCall_588441
proc url_CivicinfoDivisionsSearch_588711(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoDivisionsSearch_588710(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches for political divisions by their natural name or OCD ID.
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
  ##   query: JString
  ##        : The search query. Queries can cover any parts of a OCD ID or a human readable division name. All words given in the query are treated as required patterns. In addition to that, most query operators of the Apache Lucene library are supported. See http://lucene.apache.org/core/2_9_4/queryparsersyntax.html
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588824 = query.getOrDefault("quotaUser")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "quotaUser", valid_588824
  var valid_588838 = query.getOrDefault("alt")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = newJString("json"))
  if valid_588838 != nil:
    section.add "alt", valid_588838
  var valid_588839 = query.getOrDefault("query")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "query", valid_588839
  var valid_588840 = query.getOrDefault("oauth_token")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "oauth_token", valid_588840
  var valid_588841 = query.getOrDefault("userIp")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "userIp", valid_588841
  var valid_588842 = query.getOrDefault("key")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "key", valid_588842
  var valid_588843 = query.getOrDefault("prettyPrint")
  valid_588843 = validateParameter(valid_588843, JBool, required = false,
                                 default = newJBool(true))
  if valid_588843 != nil:
    section.add "prettyPrint", valid_588843
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

proc call*(call_588867: Call_CivicinfoDivisionsSearch_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for political divisions by their natural name or OCD ID.
  ## 
  let valid = call_588867.validator(path, query, header, formData, body)
  let scheme = call_588867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588867.url(scheme.get, call_588867.host, call_588867.base,
                         call_588867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588867, url, valid)

proc call*(call_588938: Call_CivicinfoDivisionsSearch_588709; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; query: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## civicinfoDivisionsSearch
  ## Searches for political divisions by their natural name or OCD ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   query: string
  ##        : The search query. Queries can cover any parts of a OCD ID or a human readable division name. All words given in the query are treated as required patterns. In addition to that, most query operators of the Apache Lucene library are supported. See http://lucene.apache.org/core/2_9_4/queryparsersyntax.html
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588939 = newJObject()
  var body_588941 = newJObject()
  add(query_588939, "fields", newJString(fields))
  add(query_588939, "quotaUser", newJString(quotaUser))
  add(query_588939, "alt", newJString(alt))
  add(query_588939, "query", newJString(query))
  add(query_588939, "oauth_token", newJString(oauthToken))
  add(query_588939, "userIp", newJString(userIp))
  add(query_588939, "key", newJString(key))
  if body != nil:
    body_588941 = body
  add(query_588939, "prettyPrint", newJBool(prettyPrint))
  result = call_588938.call(nil, query_588939, nil, nil, body_588941)

var civicinfoDivisionsSearch* = Call_CivicinfoDivisionsSearch_588709(
    name: "civicinfoDivisionsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/divisions",
    validator: validate_CivicinfoDivisionsSearch_588710, base: "/civicinfo/v2",
    url: url_CivicinfoDivisionsSearch_588711, schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsElectionQuery_588980 = ref object of OpenApiRestCall_588441
proc url_CivicinfoElectionsElectionQuery_588982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoElectionsElectionQuery_588981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of available elections to query.
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
  var valid_588983 = query.getOrDefault("fields")
  valid_588983 = validateParameter(valid_588983, JString, required = false,
                                 default = nil)
  if valid_588983 != nil:
    section.add "fields", valid_588983
  var valid_588984 = query.getOrDefault("quotaUser")
  valid_588984 = validateParameter(valid_588984, JString, required = false,
                                 default = nil)
  if valid_588984 != nil:
    section.add "quotaUser", valid_588984
  var valid_588985 = query.getOrDefault("alt")
  valid_588985 = validateParameter(valid_588985, JString, required = false,
                                 default = newJString("json"))
  if valid_588985 != nil:
    section.add "alt", valid_588985
  var valid_588986 = query.getOrDefault("oauth_token")
  valid_588986 = validateParameter(valid_588986, JString, required = false,
                                 default = nil)
  if valid_588986 != nil:
    section.add "oauth_token", valid_588986
  var valid_588987 = query.getOrDefault("userIp")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "userIp", valid_588987
  var valid_588988 = query.getOrDefault("key")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "key", valid_588988
  var valid_588989 = query.getOrDefault("prettyPrint")
  valid_588989 = validateParameter(valid_588989, JBool, required = false,
                                 default = newJBool(true))
  if valid_588989 != nil:
    section.add "prettyPrint", valid_588989
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

proc call*(call_588991: Call_CivicinfoElectionsElectionQuery_588980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of available elections to query.
  ## 
  let valid = call_588991.validator(path, query, header, formData, body)
  let scheme = call_588991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588991.url(scheme.get, call_588991.host, call_588991.base,
                         call_588991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588991, url, valid)

proc call*(call_588992: Call_CivicinfoElectionsElectionQuery_588980;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## civicinfoElectionsElectionQuery
  ## List of available elections to query.
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
  var query_588993 = newJObject()
  var body_588994 = newJObject()
  add(query_588993, "fields", newJString(fields))
  add(query_588993, "quotaUser", newJString(quotaUser))
  add(query_588993, "alt", newJString(alt))
  add(query_588993, "oauth_token", newJString(oauthToken))
  add(query_588993, "userIp", newJString(userIp))
  add(query_588993, "key", newJString(key))
  if body != nil:
    body_588994 = body
  add(query_588993, "prettyPrint", newJBool(prettyPrint))
  result = call_588992.call(nil, query_588993, nil, nil, body_588994)

var civicinfoElectionsElectionQuery* = Call_CivicinfoElectionsElectionQuery_588980(
    name: "civicinfoElectionsElectionQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/elections",
    validator: validate_CivicinfoElectionsElectionQuery_588981,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsElectionQuery_588982,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByAddress_588995 = ref object of OpenApiRestCall_588441
proc url_CivicinfoRepresentativesRepresentativeInfoByAddress_588997(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoRepresentativesRepresentativeInfoByAddress_588996(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Looks up political geography and representative information for a single address.
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
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeOffices: JBool
  ##                 : Whether to return information about offices and officials. If false, only the top-level district information will be returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   address: JString
  ##          : The address to look up. May only be specified if the field ocdId is not given in the URL.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
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
  var valid_589000 = query.getOrDefault("roles")
  valid_589000 = validateParameter(valid_589000, JArray, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "roles", valid_589000
  var valid_589001 = query.getOrDefault("alt")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = newJString("json"))
  if valid_589001 != nil:
    section.add "alt", valid_589001
  var valid_589002 = query.getOrDefault("includeOffices")
  valid_589002 = validateParameter(valid_589002, JBool, required = false,
                                 default = newJBool(true))
  if valid_589002 != nil:
    section.add "includeOffices", valid_589002
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
  var valid_589005 = query.getOrDefault("levels")
  valid_589005 = validateParameter(valid_589005, JArray, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "levels", valid_589005
  var valid_589006 = query.getOrDefault("key")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "key", valid_589006
  var valid_589007 = query.getOrDefault("address")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "address", valid_589007
  var valid_589008 = query.getOrDefault("prettyPrint")
  valid_589008 = validateParameter(valid_589008, JBool, required = false,
                                 default = newJBool(true))
  if valid_589008 != nil:
    section.add "prettyPrint", valid_589008
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

proc call*(call_589010: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_588995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up political geography and representative information for a single address.
  ## 
  let valid = call_589010.validator(path, query, header, formData, body)
  let scheme = call_589010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589010.url(scheme.get, call_589010.host, call_589010.base,
                         call_589010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589010, url, valid)

proc call*(call_589011: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_588995;
          fields: string = ""; quotaUser: string = ""; roles: JsonNode = nil;
          alt: string = "json"; includeOffices: bool = true; oauthToken: string = "";
          userIp: string = ""; levels: JsonNode = nil; key: string = "";
          address: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## civicinfoRepresentativesRepresentativeInfoByAddress
  ## Looks up political geography and representative information for a single address.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeOffices: bool
  ##                 : Whether to return information about offices and officials. If false, only the top-level district information will be returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   address: string
  ##          : The address to look up. May only be specified if the field ocdId is not given in the URL.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589012 = newJObject()
  var body_589013 = newJObject()
  add(query_589012, "fields", newJString(fields))
  add(query_589012, "quotaUser", newJString(quotaUser))
  if roles != nil:
    query_589012.add "roles", roles
  add(query_589012, "alt", newJString(alt))
  add(query_589012, "includeOffices", newJBool(includeOffices))
  add(query_589012, "oauth_token", newJString(oauthToken))
  add(query_589012, "userIp", newJString(userIp))
  if levels != nil:
    query_589012.add "levels", levels
  add(query_589012, "key", newJString(key))
  add(query_589012, "address", newJString(address))
  if body != nil:
    body_589013 = body
  add(query_589012, "prettyPrint", newJBool(prettyPrint))
  result = call_589011.call(nil, query_589012, nil, nil, body_589013)

var civicinfoRepresentativesRepresentativeInfoByAddress* = Call_CivicinfoRepresentativesRepresentativeInfoByAddress_588995(
    name: "civicinfoRepresentativesRepresentativeInfoByAddress",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/representatives",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByAddress_588996,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByAddress_588997,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByDivision_589014 = ref object of OpenApiRestCall_588441
proc url_CivicinfoRepresentativesRepresentativeInfoByDivision_589016(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "ocdId" in path, "`ocdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/representatives/"),
               (kind: VariableSegment, value: "ocdId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CivicinfoRepresentativesRepresentativeInfoByDivision_589015(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Looks up representative information for a single geographic division.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ocdId: JString (required)
  ##        : The Open Civic Data division identifier of the division to look up.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ocdId` field"
  var valid_589031 = path.getOrDefault("ocdId")
  valid_589031 = validateParameter(valid_589031, JString, required = true,
                                 default = nil)
  if valid_589031 != nil:
    section.add "ocdId", valid_589031
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   recursive: JBool
  ##            : If true, information about all divisions contained in the division requested will be included as well. For example, if querying ocd-division/country:us/district:dc, this would also return all DC's wards and ANCs.
  section = newJObject()
  var valid_589032 = query.getOrDefault("fields")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "fields", valid_589032
  var valid_589033 = query.getOrDefault("quotaUser")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "quotaUser", valid_589033
  var valid_589034 = query.getOrDefault("roles")
  valid_589034 = validateParameter(valid_589034, JArray, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "roles", valid_589034
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
  var valid_589038 = query.getOrDefault("levels")
  valid_589038 = validateParameter(valid_589038, JArray, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "levels", valid_589038
  var valid_589039 = query.getOrDefault("key")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "key", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
  var valid_589041 = query.getOrDefault("recursive")
  valid_589041 = validateParameter(valid_589041, JBool, required = false, default = nil)
  if valid_589041 != nil:
    section.add "recursive", valid_589041
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

proc call*(call_589043: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_589014;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up representative information for a single geographic division.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_589014;
          ocdId: string; fields: string = ""; quotaUser: string = "";
          roles: JsonNode = nil; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; levels: JsonNode = nil; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true; recursive: bool = false): Recallable =
  ## civicinfoRepresentativesRepresentativeInfoByDivision
  ## Looks up representative information for a single geographic division.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ocdId: string (required)
  ##        : The Open Civic Data division identifier of the division to look up.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   recursive: bool
  ##            : If true, information about all divisions contained in the division requested will be included as well. For example, if querying ocd-division/country:us/district:dc, this would also return all DC's wards and ANCs.
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  var body_589047 = newJObject()
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "quotaUser", newJString(quotaUser))
  if roles != nil:
    query_589046.add "roles", roles
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(query_589046, "userIp", newJString(userIp))
  add(path_589045, "ocdId", newJString(ocdId))
  if levels != nil:
    query_589046.add "levels", levels
  add(query_589046, "key", newJString(key))
  if body != nil:
    body_589047 = body
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  add(query_589046, "recursive", newJBool(recursive))
  result = call_589044.call(path_589045, query_589046, nil, nil, body_589047)

var civicinfoRepresentativesRepresentativeInfoByDivision* = Call_CivicinfoRepresentativesRepresentativeInfoByDivision_589014(
    name: "civicinfoRepresentativesRepresentativeInfoByDivision",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/representatives/{ocdId}",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByDivision_589015,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByDivision_589016,
    schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsVoterInfoQuery_589048 = ref object of OpenApiRestCall_588441
proc url_CivicinfoElectionsVoterInfoQuery_589050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CivicinfoElectionsVoterInfoQuery_589049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up information relevant to a voter based on the voter's registered address.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   returnAllAvailableData: JBool
  ##                         : If set to true, the query will return the success codeand include any partial information when it is unable to determine a matching address or unable to determine the election for electionId=0 queries.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   electionId: JString
  ##             : The unique ID of the election to look up. A list of election IDs can be obtained at https://www.googleapis.com/civicinfo/{version}/electionsIf no election ID is specified in the query and there is more than one election with data for the given voter, the additional elections are provided in the otherElections response field.
  ##   officialOnly: JBool
  ##               : If set to true, only data from official state sources will be returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   address: JString (required)
  ##          : The registered address of the voter to look up.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589051 = query.getOrDefault("returnAllAvailableData")
  valid_589051 = validateParameter(valid_589051, JBool, required = false,
                                 default = newJBool(false))
  if valid_589051 != nil:
    section.add "returnAllAvailableData", valid_589051
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("alt")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("json"))
  if valid_589054 != nil:
    section.add "alt", valid_589054
  var valid_589055 = query.getOrDefault("electionId")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("0"))
  if valid_589055 != nil:
    section.add "electionId", valid_589055
  var valid_589056 = query.getOrDefault("officialOnly")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(false))
  if valid_589056 != nil:
    section.add "officialOnly", valid_589056
  var valid_589057 = query.getOrDefault("oauth_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "oauth_token", valid_589057
  var valid_589058 = query.getOrDefault("userIp")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "userIp", valid_589058
  var valid_589059 = query.getOrDefault("key")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "key", valid_589059
  assert query != nil, "query argument is necessary due to required `address` field"
  var valid_589060 = query.getOrDefault("address")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "address", valid_589060
  var valid_589061 = query.getOrDefault("prettyPrint")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "prettyPrint", valid_589061
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

proc call*(call_589063: Call_CivicinfoElectionsVoterInfoQuery_589048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up information relevant to a voter based on the voter's registered address.
  ## 
  let valid = call_589063.validator(path, query, header, formData, body)
  let scheme = call_589063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589063.url(scheme.get, call_589063.host, call_589063.base,
                         call_589063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589063, url, valid)

proc call*(call_589064: Call_CivicinfoElectionsVoterInfoQuery_589048;
          address: string; returnAllAvailableData: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; electionId: string = "0";
          officialOnly: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## civicinfoElectionsVoterInfoQuery
  ## Looks up information relevant to a voter based on the voter's registered address.
  ##   returnAllAvailableData: bool
  ##                         : If set to true, the query will return the success codeand include any partial information when it is unable to determine a matching address or unable to determine the election for electionId=0 queries.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   electionId: string
  ##             : The unique ID of the election to look up. A list of election IDs can be obtained at https://www.googleapis.com/civicinfo/{version}/electionsIf no election ID is specified in the query and there is more than one election with data for the given voter, the additional elections are provided in the otherElections response field.
  ##   officialOnly: bool
  ##               : If set to true, only data from official state sources will be returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   address: string (required)
  ##          : The registered address of the voter to look up.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589065 = newJObject()
  var body_589066 = newJObject()
  add(query_589065, "returnAllAvailableData", newJBool(returnAllAvailableData))
  add(query_589065, "fields", newJString(fields))
  add(query_589065, "quotaUser", newJString(quotaUser))
  add(query_589065, "alt", newJString(alt))
  add(query_589065, "electionId", newJString(electionId))
  add(query_589065, "officialOnly", newJBool(officialOnly))
  add(query_589065, "oauth_token", newJString(oauthToken))
  add(query_589065, "userIp", newJString(userIp))
  add(query_589065, "key", newJString(key))
  add(query_589065, "address", newJString(address))
  if body != nil:
    body_589066 = body
  add(query_589065, "prettyPrint", newJBool(prettyPrint))
  result = call_589064.call(nil, query_589065, nil, nil, body_589066)

var civicinfoElectionsVoterInfoQuery* = Call_CivicinfoElectionsVoterInfoQuery_589048(
    name: "civicinfoElectionsVoterInfoQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/voterinfo",
    validator: validate_CivicinfoElectionsVoterInfoQuery_589049,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsVoterInfoQuery_589050,
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
