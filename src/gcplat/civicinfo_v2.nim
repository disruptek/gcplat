
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "civicinfo"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CivicinfoDivisionsSearch_597676 = ref object of OpenApiRestCall_597408
proc url_CivicinfoDivisionsSearch_597678(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CivicinfoDivisionsSearch_597677(path: JsonNode; query: JsonNode;
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
  var valid_597790 = query.getOrDefault("fields")
  valid_597790 = validateParameter(valid_597790, JString, required = false,
                                 default = nil)
  if valid_597790 != nil:
    section.add "fields", valid_597790
  var valid_597791 = query.getOrDefault("quotaUser")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "quotaUser", valid_597791
  var valid_597805 = query.getOrDefault("alt")
  valid_597805 = validateParameter(valid_597805, JString, required = false,
                                 default = newJString("json"))
  if valid_597805 != nil:
    section.add "alt", valid_597805
  var valid_597806 = query.getOrDefault("query")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "query", valid_597806
  var valid_597807 = query.getOrDefault("oauth_token")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "oauth_token", valid_597807
  var valid_597808 = query.getOrDefault("userIp")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "userIp", valid_597808
  var valid_597809 = query.getOrDefault("key")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "key", valid_597809
  var valid_597810 = query.getOrDefault("prettyPrint")
  valid_597810 = validateParameter(valid_597810, JBool, required = false,
                                 default = newJBool(true))
  if valid_597810 != nil:
    section.add "prettyPrint", valid_597810
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

proc call*(call_597834: Call_CivicinfoDivisionsSearch_597676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for political divisions by their natural name or OCD ID.
  ## 
  let valid = call_597834.validator(path, query, header, formData, body)
  let scheme = call_597834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597834.url(scheme.get, call_597834.host, call_597834.base,
                         call_597834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597834, url, valid)

proc call*(call_597905: Call_CivicinfoDivisionsSearch_597676; fields: string = "";
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
  var query_597906 = newJObject()
  var body_597908 = newJObject()
  add(query_597906, "fields", newJString(fields))
  add(query_597906, "quotaUser", newJString(quotaUser))
  add(query_597906, "alt", newJString(alt))
  add(query_597906, "query", newJString(query))
  add(query_597906, "oauth_token", newJString(oauthToken))
  add(query_597906, "userIp", newJString(userIp))
  add(query_597906, "key", newJString(key))
  if body != nil:
    body_597908 = body
  add(query_597906, "prettyPrint", newJBool(prettyPrint))
  result = call_597905.call(nil, query_597906, nil, nil, body_597908)

var civicinfoDivisionsSearch* = Call_CivicinfoDivisionsSearch_597676(
    name: "civicinfoDivisionsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/divisions",
    validator: validate_CivicinfoDivisionsSearch_597677, base: "/civicinfo/v2",
    url: url_CivicinfoDivisionsSearch_597678, schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsElectionQuery_597947 = ref object of OpenApiRestCall_597408
proc url_CivicinfoElectionsElectionQuery_597949(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CivicinfoElectionsElectionQuery_597948(path: JsonNode;
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
  var valid_597950 = query.getOrDefault("fields")
  valid_597950 = validateParameter(valid_597950, JString, required = false,
                                 default = nil)
  if valid_597950 != nil:
    section.add "fields", valid_597950
  var valid_597951 = query.getOrDefault("quotaUser")
  valid_597951 = validateParameter(valid_597951, JString, required = false,
                                 default = nil)
  if valid_597951 != nil:
    section.add "quotaUser", valid_597951
  var valid_597952 = query.getOrDefault("alt")
  valid_597952 = validateParameter(valid_597952, JString, required = false,
                                 default = newJString("json"))
  if valid_597952 != nil:
    section.add "alt", valid_597952
  var valid_597953 = query.getOrDefault("oauth_token")
  valid_597953 = validateParameter(valid_597953, JString, required = false,
                                 default = nil)
  if valid_597953 != nil:
    section.add "oauth_token", valid_597953
  var valid_597954 = query.getOrDefault("userIp")
  valid_597954 = validateParameter(valid_597954, JString, required = false,
                                 default = nil)
  if valid_597954 != nil:
    section.add "userIp", valid_597954
  var valid_597955 = query.getOrDefault("key")
  valid_597955 = validateParameter(valid_597955, JString, required = false,
                                 default = nil)
  if valid_597955 != nil:
    section.add "key", valid_597955
  var valid_597956 = query.getOrDefault("prettyPrint")
  valid_597956 = validateParameter(valid_597956, JBool, required = false,
                                 default = newJBool(true))
  if valid_597956 != nil:
    section.add "prettyPrint", valid_597956
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

proc call*(call_597958: Call_CivicinfoElectionsElectionQuery_597947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of available elections to query.
  ## 
  let valid = call_597958.validator(path, query, header, formData, body)
  let scheme = call_597958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597958.url(scheme.get, call_597958.host, call_597958.base,
                         call_597958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597958, url, valid)

proc call*(call_597959: Call_CivicinfoElectionsElectionQuery_597947;
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
  var query_597960 = newJObject()
  var body_597961 = newJObject()
  add(query_597960, "fields", newJString(fields))
  add(query_597960, "quotaUser", newJString(quotaUser))
  add(query_597960, "alt", newJString(alt))
  add(query_597960, "oauth_token", newJString(oauthToken))
  add(query_597960, "userIp", newJString(userIp))
  add(query_597960, "key", newJString(key))
  if body != nil:
    body_597961 = body
  add(query_597960, "prettyPrint", newJBool(prettyPrint))
  result = call_597959.call(nil, query_597960, nil, nil, body_597961)

var civicinfoElectionsElectionQuery* = Call_CivicinfoElectionsElectionQuery_597947(
    name: "civicinfoElectionsElectionQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/elections",
    validator: validate_CivicinfoElectionsElectionQuery_597948,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsElectionQuery_597949,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByAddress_597962 = ref object of OpenApiRestCall_597408
proc url_CivicinfoRepresentativesRepresentativeInfoByAddress_597964(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CivicinfoRepresentativesRepresentativeInfoByAddress_597963(
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
  var valid_597965 = query.getOrDefault("fields")
  valid_597965 = validateParameter(valid_597965, JString, required = false,
                                 default = nil)
  if valid_597965 != nil:
    section.add "fields", valid_597965
  var valid_597966 = query.getOrDefault("quotaUser")
  valid_597966 = validateParameter(valid_597966, JString, required = false,
                                 default = nil)
  if valid_597966 != nil:
    section.add "quotaUser", valid_597966
  var valid_597967 = query.getOrDefault("roles")
  valid_597967 = validateParameter(valid_597967, JArray, required = false,
                                 default = nil)
  if valid_597967 != nil:
    section.add "roles", valid_597967
  var valid_597968 = query.getOrDefault("alt")
  valid_597968 = validateParameter(valid_597968, JString, required = false,
                                 default = newJString("json"))
  if valid_597968 != nil:
    section.add "alt", valid_597968
  var valid_597969 = query.getOrDefault("includeOffices")
  valid_597969 = validateParameter(valid_597969, JBool, required = false,
                                 default = newJBool(true))
  if valid_597969 != nil:
    section.add "includeOffices", valid_597969
  var valid_597970 = query.getOrDefault("oauth_token")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "oauth_token", valid_597970
  var valid_597971 = query.getOrDefault("userIp")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "userIp", valid_597971
  var valid_597972 = query.getOrDefault("levels")
  valid_597972 = validateParameter(valid_597972, JArray, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "levels", valid_597972
  var valid_597973 = query.getOrDefault("key")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "key", valid_597973
  var valid_597974 = query.getOrDefault("address")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "address", valid_597974
  var valid_597975 = query.getOrDefault("prettyPrint")
  valid_597975 = validateParameter(valid_597975, JBool, required = false,
                                 default = newJBool(true))
  if valid_597975 != nil:
    section.add "prettyPrint", valid_597975
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

proc call*(call_597977: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_597962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up political geography and representative information for a single address.
  ## 
  let valid = call_597977.validator(path, query, header, formData, body)
  let scheme = call_597977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597977.url(scheme.get, call_597977.host, call_597977.base,
                         call_597977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597977, url, valid)

proc call*(call_597978: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_597962;
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
  var query_597979 = newJObject()
  var body_597980 = newJObject()
  add(query_597979, "fields", newJString(fields))
  add(query_597979, "quotaUser", newJString(quotaUser))
  if roles != nil:
    query_597979.add "roles", roles
  add(query_597979, "alt", newJString(alt))
  add(query_597979, "includeOffices", newJBool(includeOffices))
  add(query_597979, "oauth_token", newJString(oauthToken))
  add(query_597979, "userIp", newJString(userIp))
  if levels != nil:
    query_597979.add "levels", levels
  add(query_597979, "key", newJString(key))
  add(query_597979, "address", newJString(address))
  if body != nil:
    body_597980 = body
  add(query_597979, "prettyPrint", newJBool(prettyPrint))
  result = call_597978.call(nil, query_597979, nil, nil, body_597980)

var civicinfoRepresentativesRepresentativeInfoByAddress* = Call_CivicinfoRepresentativesRepresentativeInfoByAddress_597962(
    name: "civicinfoRepresentativesRepresentativeInfoByAddress",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/representatives",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByAddress_597963,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByAddress_597964,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByDivision_597981 = ref object of OpenApiRestCall_597408
proc url_CivicinfoRepresentativesRepresentativeInfoByDivision_597983(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "ocdId" in path, "`ocdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/representatives/"),
               (kind: VariableSegment, value: "ocdId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CivicinfoRepresentativesRepresentativeInfoByDivision_597982(
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
  var valid_597998 = path.getOrDefault("ocdId")
  valid_597998 = validateParameter(valid_597998, JString, required = true,
                                 default = nil)
  if valid_597998 != nil:
    section.add "ocdId", valid_597998
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
  var valid_597999 = query.getOrDefault("fields")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "fields", valid_597999
  var valid_598000 = query.getOrDefault("quotaUser")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "quotaUser", valid_598000
  var valid_598001 = query.getOrDefault("roles")
  valid_598001 = validateParameter(valid_598001, JArray, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "roles", valid_598001
  var valid_598002 = query.getOrDefault("alt")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = newJString("json"))
  if valid_598002 != nil:
    section.add "alt", valid_598002
  var valid_598003 = query.getOrDefault("oauth_token")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "oauth_token", valid_598003
  var valid_598004 = query.getOrDefault("userIp")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "userIp", valid_598004
  var valid_598005 = query.getOrDefault("levels")
  valid_598005 = validateParameter(valid_598005, JArray, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "levels", valid_598005
  var valid_598006 = query.getOrDefault("key")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "key", valid_598006
  var valid_598007 = query.getOrDefault("prettyPrint")
  valid_598007 = validateParameter(valid_598007, JBool, required = false,
                                 default = newJBool(true))
  if valid_598007 != nil:
    section.add "prettyPrint", valid_598007
  var valid_598008 = query.getOrDefault("recursive")
  valid_598008 = validateParameter(valid_598008, JBool, required = false, default = nil)
  if valid_598008 != nil:
    section.add "recursive", valid_598008
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

proc call*(call_598010: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_597981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up representative information for a single geographic division.
  ## 
  let valid = call_598010.validator(path, query, header, formData, body)
  let scheme = call_598010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598010.url(scheme.get, call_598010.host, call_598010.base,
                         call_598010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598010, url, valid)

proc call*(call_598011: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_597981;
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
  var path_598012 = newJObject()
  var query_598013 = newJObject()
  var body_598014 = newJObject()
  add(query_598013, "fields", newJString(fields))
  add(query_598013, "quotaUser", newJString(quotaUser))
  if roles != nil:
    query_598013.add "roles", roles
  add(query_598013, "alt", newJString(alt))
  add(query_598013, "oauth_token", newJString(oauthToken))
  add(query_598013, "userIp", newJString(userIp))
  add(path_598012, "ocdId", newJString(ocdId))
  if levels != nil:
    query_598013.add "levels", levels
  add(query_598013, "key", newJString(key))
  if body != nil:
    body_598014 = body
  add(query_598013, "prettyPrint", newJBool(prettyPrint))
  add(query_598013, "recursive", newJBool(recursive))
  result = call_598011.call(path_598012, query_598013, nil, nil, body_598014)

var civicinfoRepresentativesRepresentativeInfoByDivision* = Call_CivicinfoRepresentativesRepresentativeInfoByDivision_597981(
    name: "civicinfoRepresentativesRepresentativeInfoByDivision",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/representatives/{ocdId}",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByDivision_597982,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByDivision_597983,
    schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsVoterInfoQuery_598015 = ref object of OpenApiRestCall_597408
proc url_CivicinfoElectionsVoterInfoQuery_598017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CivicinfoElectionsVoterInfoQuery_598016(path: JsonNode;
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
  var valid_598018 = query.getOrDefault("returnAllAvailableData")
  valid_598018 = validateParameter(valid_598018, JBool, required = false,
                                 default = newJBool(false))
  if valid_598018 != nil:
    section.add "returnAllAvailableData", valid_598018
  var valid_598019 = query.getOrDefault("fields")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "fields", valid_598019
  var valid_598020 = query.getOrDefault("quotaUser")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "quotaUser", valid_598020
  var valid_598021 = query.getOrDefault("alt")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = newJString("json"))
  if valid_598021 != nil:
    section.add "alt", valid_598021
  var valid_598022 = query.getOrDefault("electionId")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = newJString("0"))
  if valid_598022 != nil:
    section.add "electionId", valid_598022
  var valid_598023 = query.getOrDefault("officialOnly")
  valid_598023 = validateParameter(valid_598023, JBool, required = false,
                                 default = newJBool(false))
  if valid_598023 != nil:
    section.add "officialOnly", valid_598023
  var valid_598024 = query.getOrDefault("oauth_token")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "oauth_token", valid_598024
  var valid_598025 = query.getOrDefault("userIp")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "userIp", valid_598025
  var valid_598026 = query.getOrDefault("key")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "key", valid_598026
  assert query != nil, "query argument is necessary due to required `address` field"
  var valid_598027 = query.getOrDefault("address")
  valid_598027 = validateParameter(valid_598027, JString, required = true,
                                 default = nil)
  if valid_598027 != nil:
    section.add "address", valid_598027
  var valid_598028 = query.getOrDefault("prettyPrint")
  valid_598028 = validateParameter(valid_598028, JBool, required = false,
                                 default = newJBool(true))
  if valid_598028 != nil:
    section.add "prettyPrint", valid_598028
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

proc call*(call_598030: Call_CivicinfoElectionsVoterInfoQuery_598015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up information relevant to a voter based on the voter's registered address.
  ## 
  let valid = call_598030.validator(path, query, header, formData, body)
  let scheme = call_598030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598030.url(scheme.get, call_598030.host, call_598030.base,
                         call_598030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598030, url, valid)

proc call*(call_598031: Call_CivicinfoElectionsVoterInfoQuery_598015;
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
  var query_598032 = newJObject()
  var body_598033 = newJObject()
  add(query_598032, "returnAllAvailableData", newJBool(returnAllAvailableData))
  add(query_598032, "fields", newJString(fields))
  add(query_598032, "quotaUser", newJString(quotaUser))
  add(query_598032, "alt", newJString(alt))
  add(query_598032, "electionId", newJString(electionId))
  add(query_598032, "officialOnly", newJBool(officialOnly))
  add(query_598032, "oauth_token", newJString(oauthToken))
  add(query_598032, "userIp", newJString(userIp))
  add(query_598032, "key", newJString(key))
  add(query_598032, "address", newJString(address))
  if body != nil:
    body_598033 = body
  add(query_598032, "prettyPrint", newJBool(prettyPrint))
  result = call_598031.call(nil, query_598032, nil, nil, body_598033)

var civicinfoElectionsVoterInfoQuery* = Call_CivicinfoElectionsVoterInfoQuery_598015(
    name: "civicinfoElectionsVoterInfoQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/voterinfo",
    validator: validate_CivicinfoElectionsVoterInfoQuery_598016,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsVoterInfoQuery_598017,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
